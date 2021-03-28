//https://medium.com/flutter-community/flutter-essential-what-you-need-to-know-567ad25dcd8f
//https://medium.com/flutter-community/flutter-todos-tutorial-with-flutter-bloc-d9dd833f9df3
import 'package:equatable/equatable.dart';
import 'package:song_reads/models/comment_info.dart';
import 'package:song_reads/models/models.dart';

abstract class SongState extends Equatable {
  const SongState();

  @override
  List<Object> get props => [];
}

class SongEmpty extends SongState {}

class SongLoaded extends SongState {
  final SongInfo songInfo;

  const SongLoaded({this.songInfo});

  @override
  List<Object> get props => [songInfo];
}