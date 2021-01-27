library enums;

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
