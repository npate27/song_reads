import 'dart:convert';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:song_reads/utils/secrets_utils.dart';
import 'package:song_reads/constants/literals.dart' as LiteralConstants;
import 'package:song_reads/utils/token_store.dart';

Future<bool> logInSpotifyAuthPKCE(String clientKey, String redirectUrl, AuthorizationServiceConfiguration authServiceConfig, List<String> scopes) async{
  String clientString = await loadSecretFromKey(clientKey);
  FlutterAppAuth appAuth = FlutterAppAuth();
  var authRequest = AuthorizationRequest(clientString, redirectUrl, serviceConfiguration: authServiceConfig, scopes: scopes);
  final AuthorizationResponse result = await appAuth.authorize(authRequest);
  if (result != null) {
    return getAuthRefreshToken(clientString, authServiceConfig, scopes, result.authorizationCode, result.codeVerifier);
  }
  return false;
}

bool logOutSpotify() {
  TokenStore tokenStore = TokenStore.instance;
  tokenStore.deleteValue(LiteralConstants.spotifyRefreshTokenKey);
  tokenStore.deleteValue(LiteralConstants.spotifyAccessTokenKey);
  tokenStore.deleteValue(LiteralConstants.spotifyAccessTokenExpiryKey);
  return !tokenStore.hasKey(LiteralConstants.spotifyRefreshTokenKey) && !tokenStore.hasKey(LiteralConstants.spotifyAccessTokenKey);
}

//TODO: Make codeVerifier and authCode null and make it refresh token instead
Future<bool> getAuthRefreshToken(String clientString, AuthorizationServiceConfiguration authServiceConfig, List<String> scopes, String authCode, String codeVerifier) async{
  FlutterAppAuth appAuth = FlutterAppAuth();
  final TokenResponse result = await appAuth.token(
      TokenRequest(clientString, LiteralConstants.redirectUrl, serviceConfiguration: authServiceConfig, scopes: scopes, authorizationCode: authCode, codeVerifier: codeVerifier)
  );
  if (result != null) {
    TokenStore tokenStore = TokenStore.instance;
    tokenStore.setValue(LiteralConstants.spotifyRefreshTokenKey, result.refreshToken);
    tokenStore.setValue(LiteralConstants.spotifyAccessTokenKey, result.accessToken);
    tokenStore.setValue(LiteralConstants.spotifyAccessTokenExpiryKey, result.accessTokenExpirationDateTime.toUtc().millisecondsSinceEpoch);
    return true;
  }
  return false;
}

Future<String> refreshAccessToken(String clientKey, AuthorizationServiceConfiguration authServiceConfig, List<String> scopes) async{
  String clientString = await loadSecretFromKey(clientKey);
  TokenStore tokenStore = TokenStore.instance;
  String refreshToken = tokenStore.getValue(LiteralConstants.spotifyRefreshTokenKey);
  FlutterAppAuth appAuth = FlutterAppAuth();
  final TokenResponse result = await appAuth.token(
      TokenRequest(clientString, LiteralConstants.redirectUrl, serviceConfiguration: authServiceConfig, scopes: scopes, refreshToken: refreshToken)
  );
  if (result != null) {
    tokenStore.setValue(LiteralConstants.spotifyRefreshTokenKey, result.refreshToken);
    tokenStore.setValue(LiteralConstants.spotifyAccessTokenKey, result.accessToken);
    tokenStore.setValue(LiteralConstants.spotifyAccessTokenExpiryKey, result.accessTokenExpirationDateTime.toUtc().millisecondsSinceEpoch);
    return result.accessToken;
  }
  //TODO: handle this better
  return null;
}

Future<String> base64EncodedToken(String clientKey, String secretKey) async {
  String clientId = await loadSecretFromKey(clientKey);
  String clientSecret = await loadSecretFromKey(secretKey);
  return base64.encode(utf8.encode('$clientId:$clientSecret'));
}

bool isTokenExpired(String accessTokenKeyExpiry) {
  int expiryTimeInMillis = TokenStore.instance.getValue(accessTokenKeyExpiry);
  if (expiryTimeInMillis == null) {
    return true;
  } else {
    DateTime expiryTime = DateTime.fromMillisecondsSinceEpoch(expiryTimeInMillis).toUtc();
    DateTime currentTime = DateTime.now().toUtc();
    return currentTime.isAfter(expiryTime);
  }
}

//TODO: dont store auth key, use refresh token instead
bool isUserLoggedIn(){
  return TokenStore.instance.getValue(LiteralConstants.spotifyRefreshTokenKey) != null;
}