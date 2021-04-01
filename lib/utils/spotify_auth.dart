import 'dart:convert';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:song_reads/utils/secrets_utils.dart';
import 'package:song_reads/constants/literals.dart' as LiteralConstants;
import 'package:song_reads/utils/token_store.dart';

Future<bool> logInAuthForSpotify() async{
  String clientKey = await loadSecretFromKey('spotify_client_id');
  FlutterAppAuth appAuth = FlutterAppAuth();
  var authRequest = AuthorizationRequest(
    clientKey,
    'songreads:/',
    serviceConfiguration: AuthorizationServiceConfiguration('https://accounts.spotify.com/authorize', 'https://accounts.spotify.com/api/token'),
    scopes: ['user-read-recently-played','user-read-currently-playing'],
  );
  final AuthorizationResponse result = await appAuth.authorize(authRequest);
  if (result != null) {
    TokenStore tokenStore = await TokenStore.instance;
    //TODO: dont store auth key, use refresh token instead
    tokenStore.setValue(LiteralConstants.spotifyAuthCodeKey, result.authorizationCode);
    tokenStore.setValue(LiteralConstants.spotifyCodeVerifierKey, result.codeVerifier);
    return true;
  }
  return false;
}



// https://developer.spotify.com/documentation/general/guides/authorization-guide/
Future<String> spotifyBase64EncodedToken() async {
  String clientId = await loadSecretFromKey('spotify_client_id');
  String clientSecret = await loadSecretFromKey('spotify_client_secret');
  return base64.encode(utf8.encode('$clientId:$clientSecret'));
}


bool isTokenExpired(TokenStore tokenStore, String accessTokenKeyExpiry) {
  int expiryTimeInMillis = tokenStore.getValue(accessTokenKeyExpiry);
  if (expiryTimeInMillis == null) {
    return true;
  } else {
    DateTime expiryTime = DateTime.fromMillisecondsSinceEpoch(expiryTimeInMillis).toUtc();
    DateTime currentTime = DateTime.now().toUtc();
    return currentTime.isAfter(expiryTime);
  }
}

//TODO: dont store auth key, use refresh token instead
bool isUserLoggedIn(TokenStore tokenStore, String authCodeKey){
  return tokenStore.getValue(authCodeKey) != null;
}