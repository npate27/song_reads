import 'package:song_reads/models/source_model.dart';

class RedditThread extends SourceModel {
  final String id;
  final int likes;
  final String title;
  final String subreddit;
  final String author;
  final int numComments;

  RedditThread({this.id, this.likes, this.title, this.subreddit,
      this.author, this.numComments});

  factory RedditThread.fromJson(Map<String, dynamic> json) {
    return RedditThread(
        id: json['id'],
        likes: json['score'],
        title: json['title'],
        subreddit: json['subreddit'],
        author: json['author'],
        numComments: json['numComments'],
    );
  }
}