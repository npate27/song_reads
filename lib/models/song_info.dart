class SongInfo {
  final String title;
  final String artist;
  final String album;
  final String artworkImage;

  SongInfo({this.title, this.artist, this.album, this.artworkImage});

  factory SongInfo.fromJson(Map<String, dynamic> json) {
    return SongInfo(
        title: json['name'],
        artist: json['artists'][0]['name'],
        album: json['album']['name'],
        artworkImage: json['album']['images'][0]['url']
    );
  }
}