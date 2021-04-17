import 'package:equatable/equatable.dart';
import 'package:html_unescape/html_unescape_small.dart';

class SongInfo extends Equatable{
  final String title;
  final String artist;
  final String album;
  final String artworkImage;

  SongInfo({this.title, this.artist, this.album, this.artworkImage});

  //TODO: parse better for multiple artists
  factory SongInfo.fromJson(Map<String, dynamic> json) {
    final HtmlUnescape unescape = HtmlUnescape();
    return SongInfo(
        title: unescape.convert(json['name']),
        artist: unescape.convert(json['artists'][0]['name']),
        album: unescape.convert(json['album']['name']),
        artworkImage: json['album']['images'][0]['url']
    );
  }

  @override
  List<Object> get props => [title, artist, album];
}