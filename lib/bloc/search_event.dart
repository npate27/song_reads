//https://medium.com/flutter-community/flutter-essential-what-you-need-to-know-567ad25dcd8f
//https://medium.com/flutter-community/flutter-todos-tutorial-with-flutter-bloc-d9dd833f9df3

import 'package:equatable/equatable.dart';
import 'package:song_reads/constants/enums.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class FetchSources extends SearchEvent {
  final String title;
  final String artist;

  FetchSources({this.title, this.artist});

  @override
  List<Object> get props => [title, artist];
}

class FetchComments extends SearchEvent {
  final String id;
  final CommentSource source;

  FetchComments({this.id, this.source});

  @override
  List<Object> get props => [id, source];
}