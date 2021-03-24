import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:song_reads/models/models.dart';
import 'package:song_reads/constants/literals.dart' as LiteralConstants;
import 'package:song_reads/utils/api_utils.dart';
import 'package:song_reads/utils/token_store.dart';

class SpotifyApiClient {
  final http.Client httpClient;

  SpotifyApiClient({@required this.httpClient,}) : assert(httpClient != null);

  Future<String> getAccessToken() async {
    final uriEncoded = Uri.encodeFull(LiteralConstants.spotifyAuthTokenUrl);
    final authToken = await spotifyBase64EncodedToken();

    TokenStore tokenStore = await TokenStore.instance;
    if (isTokenExpired(tokenStore, LiteralConstants.spotifyAccessTokenExpiryKey)) {
      final response = parseResponse(await httpClient.post(
        uriEncoded,
        headers: {
          'Content-type': 'application/x-www-form-urlencoded',
          'Authorization': 'Basic $authToken'
        },
        body: 'grant_type=client_credentials'
      ));
      tokenStore.setAccessToken(LiteralConstants.spotifyAccessTokenKey, response['access_token']);
      tokenStore.setAccessTokenExpiry(LiteralConstants.spotifyAccessTokenExpiryKey, DateTime.now().add(Duration(seconds: response['expires_in'])).toUtc().millisecondsSinceEpoch);
      return response['access_token'];
    }  else {
      return tokenStore.accessTokenInfoFromKey(LiteralConstants.spotifyAccessTokenKey);
    }
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

