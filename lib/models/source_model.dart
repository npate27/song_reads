import 'package:song_reads/constants/enums.dart';

abstract class Source {
  final String id;
  final int likes;
  final CommentSource commentSource;

  Source({this.id, this.likes, this.commentSource});

  @override
  String toString() => '${commentSource.inString} {id: $id}';
}