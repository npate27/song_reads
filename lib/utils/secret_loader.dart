// https://medium.com/@sokrato/storing-your-secret-keys-in-flutter-c0b9af1c0f69

import 'dart:async' show Future;
import 'dart:convert' show json;
import 'package:flutter/services.dart' show rootBundle;

class SecretLoader {
  final String secretPath;
  final String key;

  SecretLoader({this.secretPath, this.key});

  Future<String> load() {
    return rootBundle.loadStructuredData(this.secretPath, (jsonStr) async {
          return json.decode(jsonStr)[key];
        });
  }
}