import 'package:song_reads/models/source_model.dart';

class YoutubeVideo extends SourceModel {
  final String id;
  final int likes;
  final String title;
  final String channelTitle;
  final int numComments;

  YoutubeVideo({this.id, this.likes, this.title, this.channelTitle, this.numComments});

  factory YoutubeVideo.fromJson(Map<String, dynamic> json) {
    final int likes = int.parse(json['statistics']['likeCount']);
    final int dislikes = int.parse(json['statistics']['dislikeCount']);

    return YoutubeVideo(
        id: json['id'],
        //Setting this as a percentage for readability
        likes: (100 * likes / (likes + dislikes) ).ceil(),
        title: json['snippet']['title'],
        channelTitle: json['snippet']['channelTitle'],
        numComments: int.parse(json['statistics']['commentCount']),
    );
  }
}