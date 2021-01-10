class SongResult {
  final String resultTitle;
  final String poster;
  final int commentCount;
  final int likes;

  SongResult({this.resultTitle, this.poster, this.commentCount, this.likes});

  factory SongResult.fromJson(Map<String, dynamic> json) {
    return SongResult(
        resultTitle: json['resultTitle'],
        poster: json['poster'],
        commentCount: json['commentCount'],
        likes: json['likes']
    );
  }
}