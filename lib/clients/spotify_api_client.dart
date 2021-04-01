import 'package:flutter/foundation.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart' as http;
import 'package:song_reads/models/models.dart';
import 'package:song_reads/constants/literals.dart' as LiteralConstants;
import 'package:song_reads/utils/api_utils.dart';
import 'package:song_reads/utils/secrets_utils.dart';
import 'package:song_reads/utils/spotify_auth.dart';
import 'package:song_reads/utils/token_store.dart';

class SpotifyApiClient {
  final http.Client httpClient;

  SpotifyApiClient({@required this.httpClient,}) : assert(httpClient != null);

  Future<String> getAccessTokenWithAuth(TokenStore tokenStore) async {
    String clientKey = await loadSecretFromKey('spotify_client_id');
    if (isTokenExpired(tokenStore, LiteralConstants.spotifyAccessTokenExpiryKey)) {
      //TODO: another if statement here for refresh tokens
      FlutterAppAuth appAuth = FlutterAppAuth();
      final codeVerifier = tokenStore.getValue(
          LiteralConstants.spotifyCodeVerifierKey);
      final authCode = tokenStore.getValue(
          LiteralConstants.spotifyAuthCodeKey);
      final TokenResponse result = await appAuth.token(TokenRequest(
          clientKey,
          'songreads:/',
          serviceConfiguration: AuthorizationServiceConfiguration(
              'https://accounts.spotify.com/authorize',
              'https://accounts.spotify.com/api/token'),
          scopes: ['user-read-recently-played', 'user-read-currently-playing'],
          authorizationCode: authCode,
          codeVerifier: codeVerifier
      ));
      if (result != null) {
        tokenStore.setValue(
            LiteralConstants.spotifyRefreshTokenKey, result.refreshToken);
        tokenStore.setValue(
            LiteralConstants.spotifyAccessTokenKey, result.accessToken);
        tokenStore.setValue(
            LiteralConstants.spotifyAccessTokenExpiryKey,
            result.accessTokenExpirationDateTime
                .toUtc()
                .millisecondsSinceEpoch);
        return result.accessToken;
      }
      //TODO handle this better
      return null;
    }
    else {
      return tokenStore.getValue(LiteralConstants.spotifyAccessTokenKey);
    }
  }

  Future<String> getAccessTokenWithoutAuth(TokenStore tokenStore) async {
    if (isTokenExpired(tokenStore, LiteralConstants.spotifyAccessTokenExpiryKey)) {
      final uriEncoded = Uri.encodeFull(LiteralConstants.spotifyAuthTokenUrl);
      final authToken = await spotifyBase64EncodedToken();
      final response = parseResponse(await httpClient.post(
          uriEncoded,
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
    return isUserLoggedIn(tokenStore, LiteralConstants.spotifyAuthCodeKey) ? getAccessTokenWithAuth(tokenStore) : getAccessTokenWithoutAuth(tokenStore);
  }

  Future<List<SongInfo>> getSongSearchResults(String text) async {
    final uriEncoded = Uri.encodeFull('${LiteralConstants.baseSpotifyApiUrl}/search?q=$text&type=track&market=US&limit=10&offset=5');
    final accessToken = await getAccessToken();
    final response = parseResponse(await httpClient.get(
        uriEncoded,
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

