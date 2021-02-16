import 'package:song_reads/constants/enums.dart';
import 'package:song_reads/models/source_model.dart';

class CommentInfo {
  final String id;
  final int likes;
  final String user;
  final String text;
  final CommentSource commentSource;

  CommentInfo({this.id, this.likes, this.user, this.text, this.commentSource});

  factory CommentInfo.fromJson(Map<String, dynamic> json, CommentSource commentSource) {
    CommentInfo info;
    switch (commentSource) {
      case CommentSource.genius:
        // TODO: Handle this case.
        break;
      case CommentSource.youtube:
        info = CommentInfo(
          id: json['id'],
          likes: json['snippet']['topLevelComment']['likeCount'],
          user: json['snippet']['topLevelComment']['snippet']['authorDisplayName'],
          text: json['snippet']['topLevelComment']['snippet']['textDisplay'],
          commentSource: commentSource,
        );
        break;
      case CommentSource.reddit:
        info = CommentInfo(
          id: json['id'],
          likes: json['score'],
          user: json['author'],
          text: json['body'],
          commentSource: commentSource,
        );
        break;
    }
    return info;
  }
}