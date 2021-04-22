import 'package:song_reads/constants/enums.dart';
import 'package:song_reads/models/source_model.dart';
import 'package:html_unescape/html_unescape_small.dart';

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
    final HtmlUnescape unescape = HtmlUnescape();
    return YouTubeVideo(
        id: json['id'],
        likes: int.parse(json['statistics']['likeCount']) ?? 0,
        title: unescape.convert(json['snippet']['title']),
        channelTitle: unescape.convert(json['snippet']['channelTitle']),
        numComments: json['statistics'].containsKey('commentCount') ? int.parse(json['statistics']['commentCount']) : 0,
    );
  }
}