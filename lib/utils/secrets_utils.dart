// https://medium.com/@sokrato/storing-your-secret-keys-in-flutter-c0b9af1c0f69

import 'dart:async' show Future;
import 'dart:convert' show json;
import 'package:flutter/services.dart' show rootBundle;

//Result is cached after first call. https://api.flutter.dev/flutter/services/CachingAssetBundle/loadStructuredData.html
Future<Map<String,dynamic>> loadSecretsJson() {
  return rootBundle.loadStructuredData('assets/secrets.json', (jsonStr) async {
        return json.decode(jsonStr);
      });
}

Future<String> loadSecretFromKey(String key) async {
  Map<String,dynamic> secretJson = await loadSecretsJson();
  return secretJson[key];
}