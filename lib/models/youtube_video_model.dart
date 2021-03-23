import 'package:song_reads/constants/enums.dart';
import 'package:song_reads/models/source_model.dart';

class YouTubeVideo extends Source {
  final String id;
  final int likes;
  final String title;
  final String channelTitle;
  final int numComments;
  final CommentSource commentSource = CommentSource.youtube;

  YouTubeVideo({this.id, this.likes, this.title, this.channelTitle, this.numComments});

  factory YouTubeVideo.fromJson(Map<String, dynamic> json) {
    // final int dislikes = int.parse(json['statistics']['dislikeCount']);
    return YouTubeVideo(
        id: json['id'],
        likes: int.parse(json['statistics']['likeCount']),
        title: json['snippet']['title'],
        channelTitle: json['snippet']['channelTitle'],
        numComments: int.parse(json['statistics']['commentCount']),
    );
  }
}