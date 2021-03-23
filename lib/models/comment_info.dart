import 'package:song_reads/constants/enums.dart';

class CommentInfo {
  final String id;
  final int likes;
  final String user;
  final String text;
  //TODO: add comment date
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
          likes: json['snippet']['topLevelComment']['snippet']['likeCount'],
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