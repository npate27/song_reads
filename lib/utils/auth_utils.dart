import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:song_reads/clients/http_client_singleton.dart';
import 'package:song_reads/clients/spotify_api_client.dart';
import 'package:song_reads/utils/api_utils.dart';
import 'package:song_reads/utils/secrets_utils.dart';
import 'package:song_reads/constants/literals.dart' as LiteralConstants;
import 'package:song_reads/utils/token_store.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

Future<bool> logInSpotifyAuthPKCE(String clientKey, String redirectUrl, AuthorizationServiceConfiguration authServiceConfig, List<String> scopes) async{
  String clientString = await loadSecretFromKey(clientKey);
  if(kIsWeb) {
    //Taken from https://github.com/dart-lang/oauth2/blob/master/lib/src/authorization_code_grant.dart
    String _charset =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';
    String codeVerifier = List.generate(128, (i) => _charset[Random.secure().nextInt(_charset.length)]).join();
    String codeChallenge = base64Url.encode(sha256.convert(ascii.encode(codeVerifier)).bytes).replaceAll('=', '');
    TokenStore tokenStore = TokenStore.instance;
    tokenStore.setValue(LiteralConstants.spotifyCodeVerifierKey, codeVerifier);

    final url = Uri.https('accounts.spotify.com', '/authorize', {
      'response_type': 'code',
      'client_id': clientString,
      'redirect_uri': LiteralConstants.webRedirectUrl,
      'scope': SpotifyApiClient.userListeningScopes.join(' '),
      'code_challenge_method': 'S256',
      'code_challenge': codeChallenge
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      html.window.location.replace(url.toString());
    });
  } else {
    FlutterAppAuth appAuth = FlutterAppAuth();
    var authRequest = AuthorizationRequest(
        clientString, redirectUrl, serviceConfiguration: authServiceConfig, scopes: scopes);
    final AuthorizationResponse result = await appAuth.authorize(authRequest);
    if (result != null) {
      return getAuthRefreshToken(clientString, authServiceConfig, scopes, result.authorizationCode, result.codeVerifier);
    }
    return false;
  }
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
  TokenStore tokenStore = TokenStore.instance;

  if(kIsWeb) {
    String clientString = await loadSecretFromKey(LiteralConstants.spotifyClientKey);
    String codeVerifier = tokenStore.getValue(LiteralConstants.spotifyCodeVerifierKey);
    final result = parseResponse(await AppHttpClient().client.post(
        Uri.parse(Uri.encodeFull(LiteralConstants.spotifyAuthTokenUrl)),
        headers: {
          'Content-type': 'application/x-www-form-urlencoded'
        },
        body: {
          'grant_type': 'authorization_code',
          'code': authCode,
          'client_id': clientString,
          'code_verifier': codeVerifier,
          'redirect_uri':  LiteralConstants.webRedirectUrl
        },
        encoding: Encoding.getByName('utf-8')
    ));
    if (result != null) {
      tokenStore.setValue(LiteralConstants.spotifyRefreshTokenKey, result['refresh_token']);
      tokenStore.setValue(LiteralConstants.spotifyAccessTokenKey, result['access_token']);
      tokenStore.setValue(LiteralConstants.spotifyAccessTokenExpiryKey, DateTime.now().add(Duration(seconds: result['expires_in'])).toUtc().millisecondsSinceEpoch);
      return true;
    }
    return false;
  } else {
    FlutterAppAuth appAuth = FlutterAppAuth();
    final TokenResponse result = await appAuth.token(
        TokenRequest(clientString, LiteralConstants.redirectUrl, serviceConfiguration: authServiceConfig, scopes: scopes, authorizationCode: authCode, codeVerifier: codeVerifier)
    );
    if (result != null) {
      tokenStore.setValue(LiteralConstants.spotifyRefreshTokenKey, result.refreshToken);
      tokenStore.setValue(LiteralConstants.spotifyAccessTokenKey, result.accessToken);
      tokenStore.setValue(LiteralConstants.spotifyAccessTokenExpiryKey, result.accessTokenExpirationDateTime.toUtc().millisecondsSinceEpoch);
      return true;
    }
    return false;
  }
}

Future<String> refreshAccessToken(String clientKey, AuthorizationServiceConfiguration authServiceConfig, List<String> scopes) async{
  String clientString = await loadSecretFromKey(clientKey);
  TokenStore tokenStore = TokenStore.instance;
  String refreshToken = tokenStore.getValue(LiteralConstants.spotifyRefreshTokenKey);
  if(kIsWeb) {
    final result = parseResponse(await AppHttpClient().client.post(
        Uri.parse(Uri.encodeFull(LiteralConstants.spotifyAuthTokenUrl)),
        headers: {
          'Content-type': 'application/x-www-form-urlencoded'
        },
        body: {
          'grant_type': 'refresh_token',
          'refresh_token': refreshToken,
          'client_id': clientString
        },
        encoding: Encoding.getByName('utf-8')
    ));
    if (result != null) {
      tokenStore.setValue(LiteralConstants.spotifyRefreshTokenKey, result['refresh_token']);
      tokenStore.setValue(LiteralConstants.spotifyAccessTokenKey, result['access_token']);
      tokenStore.setValue(LiteralConstants.spotifyAccessTokenExpiryKey, DateTime.now().add(Duration(seconds: result['expires_in'])).toUtc().millisecondsSinceEpoch);
      return result['access_token'];
    }
    //TODO: handle this better
    return null;
  } else {
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