import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:song_reads/utils/secrets_utils.dart';
import 'package:song_reads/utils/token_store.dart';

dynamic parseResponse(http.Response response) {
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load response');
  }
}

// https://developer.spotify.com/documentation/general/guides/authorization-guide/
Future<String> spotifyBase64EncodedToken() async {
  String clientId = await loadSecretFromKey('spotify_client_id');
  String clientSecret = await loadSecretFromKey('spotify_client_secret');
  return base64.encode(utf8.encode('$clientId:$clientSecret'));
}

bool isTokenExpired(TokenStore tokenStore, String accessTokenKeyExpiry) {
  int expiryTimeInMillis = tokenStore.accessTokenInfoFromKey(accessTokenKeyExpiry);
  if (expiryTimeInMillis == null ) {
    return true;
  } else {
    DateTime expiryTime = DateTime.fromMillisecondsSinceEpoch(expiryTimeInMillis).toUtc();
    DateTime currentTime = DateTime.now().toUtc();
    return currentTime.isAfter(expiryTime);
  }
}