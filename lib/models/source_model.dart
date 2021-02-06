import 'package:equatable/equatable.dart';
import 'package:song_reads/constants/enums.dart';

abstract class Source extends Equatable{
  final String id;
  final int likes;
  final CommentSource commentSource;

  Source({this.id, this.likes, this.commentSource});

  @override
  String toString() => '${commentSource.inString} {id: $id, likes: $likes}';

  @override
  List<Object> get props => [id, likes, commentSource];
}