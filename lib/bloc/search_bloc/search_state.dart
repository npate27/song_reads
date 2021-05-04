//https://medium.com/flutter-community/flutter-essential-what-you-need-to-know-567ad25dcd8f
//https://medium.com/flutter-community/flutter-todos-tutorial-with-flutter-bloc-d9dd833f9df3
import 'package:equatable/equatable.dart';
import 'package:song_reads/models/comment_info.dart';
import 'package:song_reads/models/models.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchEmpty extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSourceLoaded extends SearchState {
  final List<Source> songResults;
  final List<Source> albumResults;

  const SearchSourceLoaded({this.songResults, this.albumResults});

  @override
  List<Object> get props => [songResults, albumResults];
}

class SearchCommentsLoaded extends SearchState {
  final List<CommentInfo> results;

  const SearchCommentsLoaded({this.results});

  @override
  List<Object> get props => [results];
}

class SearchError extends SearchState {}