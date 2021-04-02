//https://medium.com/flutter-community/flutter-essential-what-you-need-to-know-567ad25dcd8f
//https://medium.com/flutter-community/flutter-todos-tutorial-with-flutter-bloc-d9dd833f9df3
import 'package:equatable/equatable.dart';
import 'package:song_reads/models/models.dart';

abstract class SongState extends Equatable {
  const SongState();

  @override
  List<Object> get props => [];
}

class SongInit extends SongState{}

class SongDiscovery extends SongState {
  final bool isLoggedIn;

  const SongDiscovery({this.isLoggedIn});

  @override
  List<Object> get props => [isLoggedIn];
}

class SongLoaded extends SongState {
  final SongInfo songInfo;
  final int delayNextQueryMs;

  const SongLoaded({this.songInfo, this.delayNextQueryMs});

  @override
  List<Object> get props => [songInfo];
}