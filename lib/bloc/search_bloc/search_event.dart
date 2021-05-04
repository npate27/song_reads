//https://medium.com/flutter-community/flutter-essential-what-you-need-to-know-567ad25dcd8f
//https://medium.com/flutter-community/flutter-todos-tutorial-with-flutter-bloc-d9dd833f9df3

import 'package:equatable/equatable.dart';
import 'package:song_reads/constants/enums.dart';
import 'package:song_reads/models/models.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class FetchSources extends SearchEvent {
  final SongInfo songInfo;
  final String currentAlbum;

  FetchSources({this.songInfo, this.currentAlbum});

  @override
  List<Object> get props => [songInfo, currentAlbum];
}

class FetchComments extends SearchEvent {
  final String id;
  final CommentSource source;

  FetchComments({this.id, this.source});

  @override
  List<Object> get props => [id, source];
}