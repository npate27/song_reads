class SongInfo {
  final String songTitle;
  final String artist;
  final String albumTitle;
  final DateTime releaseDate;

  SongInfo({this.songTitle, this.artist, this.albumTitle, this.releaseDate});

  factory SongInfo.fromJson(Map<String, dynamic> json) {
    return SongInfo(
      songTitle: json['title'],
      artist: json['artist'],
      albumTitle: json['albumTitle'],
      releaseDate: DateTime.parse(json['releaseDate'])
    );
  }
}