// https://medium.com/@sokrato/storing-your-secret-keys-in-flutter-c0b9af1c0f69

import 'dart:async' show Future;
import 'dart:convert' show json;
import 'package:flutter/services.dart' show rootBundle;

Future<String> loadSecret({String secretPath, String key}) {
  return rootBundle.loadStructuredData(secretPath, (jsonStr) async {
        return json.decode(jsonStr)[key];
      });
}