import 'package:song_reads/constants/enums.dart';
import 'package:song_reads/models/source_model.dart';

class GeniusSong extends Source {
  final String id;
  final String title;
  final int likes;
  final int numComments;
  final CommentSource commentSource = CommentSource.genius;

  GeniusSong({this.id, this.title, this.likes, this.numComments});

  factory GeniusSong.fromJson(Map<String, dynamic> json) {
    return GeniusSong(
        id: json['id'].toString(),
        title: json['full_title'],
        likes: json['pyongs_count'] ?? 0,
        numComments: json['comments_count'] ?? 0
    );
  }
}