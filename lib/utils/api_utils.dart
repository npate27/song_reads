import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:song_reads/utils/secrets_utils.dart';

Map<String,dynamic> parseResponse(http.Response response) {
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load response');
  }
}

// https://developer.spotify.com/documentation/general/guides/authorization-guide/
Future<String> spotifyBase64EncodedToken() async {
  String clientId = await loadSecret(secretPath: 'assets/secrets.json', key: 'spotify_client_id');
  String clientSecret = await loadSecret(secretPath: 'assets/secrets.json', key: 'spotify_client_secret');
  return base64.encode(utf8.encode('$clientId:$clientSecret'));
}