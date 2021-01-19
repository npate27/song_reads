library enums;

import 'package:flutter/foundation.dart';
import 'package:song_reads/constants/literals.dart' as LiteralConstants;

enum CommentSource {
  genius,
  youtube,
  reddit,
}

extension CommentSourceImage on CommentSource {
  String get name => describeEnum(this);
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