import 'package:flutter/foundation.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart' as http;
import 'package:song_reads/models/models.dart';
import 'package:song_reads/constants/literals.dart' as LiteralConstants;
import 'package:song_reads/utils/api_utils.dart';
import 'package:song_reads/utils/secrets_utils.dart';
import 'package:song_reads/utils/auth_utils.dart';
import 'package:song_reads/utils/token_store.dart';

// https://developer.spotify.com/documentation/general/guides/authorization-guide/
class SpotifyApiClient {
  final http.Client httpClient;
  static final AuthorizationServiceConfiguration authConfig = AuthorizationServiceConfiguration(LiteralConstants.spotifyAuthUrl, LiteralConstants.spotifyAuthTokenUrl);
  static final List<String> userListeningScopes = ['user-read-recently-played','user-read-currently-playing'];

  SpotifyApiClient({@required this.httpClient,}) : assert(httpClient != null);

  Future<String> getAccessTokenWithAuth(TokenStore tokenStore) async {
    if (isTokenExpired(tokenStore, LiteralConstants.spotifyAccessTokenExpiryKey)) {
        return refreshAccessToken(LiteralConstants.spotifyClientKey, authConfig, userListeningScopes);
    }
    else {
      return tokenStore.getValue(LiteralConstants.spotifyAccessTokenKey);
    }
  }

  Future<String> getAccessTokenWithoutAuth(TokenStore tokenStore) async {
    if (isTokenExpired(tokenStore, LiteralConstants.spotifyAccessTokenExpiryKey)) {
      final authToken = await base64EncodedToken(LiteralConstants.spotifyClientKey, LiteralConstants.spotifySecretKey);
      final response = parseResponse(await httpClient.post(
          Uri.parse(Uri.encodeFull(LiteralConstants.spotifyAuthTokenUrl)),
          headers: {
            'Content-type': 'application/x-www-form-urlencoded',
            'Authorization': 'Basic $authToken'
          },
          body: 'grant_type=client_credentials'
      ));
      tokenStore.setValue(LiteralConstants.spotifyAccessTokenKey, response['access_token']);
      tokenStore.setValue(LiteralConstants.spotifyAccessTokenExpiryKey, DateTime.now().add(Duration(seconds: response['expires_in'])).toUtc().millisecondsSinceEpoch);
      return response['access_token'];
    }
    else {
      return tokenStore.getValue(LiteralConstants.spotifyAccessTokenKey);
    }
  }

  Future<String> getAccessToken() async {
    TokenStore tokenStore = await TokenStore.instance;
    return isUserLoggedIn(tokenStore) ? getAccessTokenWithAuth(tokenStore) : getAccessTokenWithoutAuth(tokenStore);
  }

  Future<List<Object>> getCurrentlyPlayingSong() async{
    TokenStore tokenStore = await TokenStore.instance;
    if (isUserLoggedIn(tokenStore)) {
      final accessToken = await getAccessTokenWithAuth(tokenStore);
      final response = parseResponse(await httpClient.get(
          Uri.parse(Uri.encodeFull('${LiteralConstants.baseSpotifyApiUrl}/me/player/currently-playing?market=US')),
          headers: {
            'Content-type': 'application/json',
            'Authorization': 'Bearer $accessToken'
          }
      ));
      if (response != null) {
        SongInfo songInfo = SongInfo.fromJson(response['item']);
        final int currentSongProgressMs = response['progress_ms'];
        final int songDurationMs = response['item']['duration_ms'];
        final int delayNextCurrentSongQueryMs = songDurationMs - currentSongProgressMs;
        return [songInfo, delayNextCurrentSongQueryMs];
      }
      return [];
    }
    else {
      return null;
    }
  }

  Future<List<SongInfo>> getSongSearchResults(String text, [String accessToken]) async {
    if(accessToken == null) {
      accessToken = await getAccessToken();
    }
    final response = parseResponse(await httpClient.get(
        Uri.parse(Uri.encodeFull('${LiteralConstants.baseSpotifyApiUrl}/search?q=$text&type=track&market=US&limit=10&offset=5')),
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        }
    ));
    List<dynamic> results = response['tracks']['items'];
    final List<SongInfo> searchResults = results.map((result) => SongInfo.fromJson(result)).toList();
    return searchResults;
  }
}

