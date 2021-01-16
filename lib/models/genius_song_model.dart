import 'package:song_reads/models/source_model.dart';

class GeniusSong extends SourceModel {
  final String id;
  final int likes;

  GeniusSong({this.id, this.likes});

  factory GeniusSong.fromJson(Map<String, dynamic> json) {
    return GeniusSong(
        id: json['id'].toString(),
        likes: json['pyongs_count'],
    );
  }
}