import 'package:song_reads/constants/enums.dart';
import 'package:song_reads/models/source_model.dart';

class GeniusSong extends Source {
  final String id;
  final int likes;
  final CommentSource commentSource = CommentSource.genius;

  GeniusSong({this.id, this.likes});

  factory GeniusSong.fromJson(Map<String, dynamic> json) {
    return GeniusSong(
        id: json['id'].toString(),
        likes: json['pyongs_count'],
    );
  }
}