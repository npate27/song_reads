//https://medium.com/flutter-community/flutter-essential-what-you-need-to-know-567ad25dcd8f
//https://medium.com/flutter-community/flutter-todos-tutorial-with-flutter-bloc-d9dd833f9df3

import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class FetchSources extends SearchEvent {
  final String title;
  final String artist;

  FetchSources({this.title, this.artist});

  @override
  List<Object> get props => [];
}
//TODO: Add FetchComments (split by source?)