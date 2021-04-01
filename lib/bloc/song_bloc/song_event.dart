//https://medium.com/flutter-community/flutter-essential-what-you-need-to-know-567ad25dcd8f
//https://medium.com/flutter-community/flutter-todos-tutorial-with-flutter-bloc-d9dd833f9df3

import 'package:equatable/equatable.dart';
import 'package:song_reads/models/models.dart';

abstract class SongEvent extends Equatable {
  const SongEvent();
}

class FindCurrentlyPlayingSpotifySong extends SongEvent {
  @override
  List<Object> get props => [];
}

class UpdateSong extends SongEvent {
  final SongInfo songInfo;

  UpdateSong({this.songInfo});

  @override
  List<Object> get props => [songInfo];
}