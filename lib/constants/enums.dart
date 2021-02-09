library enums;

import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:strings/strings.dart';
import 'package:song_reads/constants/literals.dart' as LiteralConstants;

enum CommentSource {
  genius,
  youtube,
  reddit,
}

extension CommentSourceStringValue on CommentSource {
  String get inString => describeEnum(this);
}

extension CommentSourceImage on CommentSource {
  // ignore: missing_return
  String get sourceImagePath {
    const String logosPath = 'assets/images/logos';
    switch (this) {
      case CommentSource.genius:
        return logosPath + "/genius-logo.png";
      case CommentSource.youtube:
        return logosPath + "/youtube-logo.png";
      case CommentSource.reddit:
        return logosPath + "/reddit-logo.png";
    }
  }
}

extension CapitalizedSourceString on CommentSource {
  String get capitalizedSource {
      return capitalize(describeEnum(this));
    }
}

extension CommentSourceResultsDataPath on CommentSource {
  // ignore: missing_return
  List<dynamic> resultsFromResponse(Map<String, dynamic> resultJson, [int maxResults]) {
    switch (this) {
      case CommentSource.genius:
        return resultJson['response']['hits'];
      case CommentSource.youtube:
        return resultJson['items'].take(maxResults).toList();
      case CommentSource.reddit:
        return resultJson['data']['children'].take(maxResults).toList();
    }
  }
}

extension CommentSourceIconBaseColor on CommentSource {
  // ignore: missing_return
  Color get sourceImageBaseColor {
    switch (this) {
      case CommentSource.genius:
        return Color(int.parse('0xFFF6F068'));
      case CommentSource.youtube:
        return Color(int.parse('0xFFFF0000'));
      case CommentSource.reddit:
        return Color(int.parse('0xFFFF4500'));
    }
  }
}
