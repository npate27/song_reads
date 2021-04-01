//https://medium.com/flutter-community/flutter-essential-what-you-need-to-know-567ad25dcd8f
//https://medium.com/flutter-community/flutter-todos-tutorial-with-flutter-bloc-d9dd833f9df3
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:song_reads/bloc/blocs.dart';
import 'package:song_reads/models/models.dart';
import 'package:song_reads/repositories/spotify_repository.dart';


class SongBloc extends Bloc<SongEvent, SongState> {
  final SpotifyRepository spotifyRepository;

  SongBloc({@required this.spotifyRepository}) : assert(spotifyRepository != null), super(SongEmpty());

  @override
  Stream<SongState> mapEventToState(SongEvent event) async*{
    if (event is FindCurrentlyPlayingSpotifySong) {
      SongInfo songInfo = await spotifyRepository.getCurrentlyPlayingSong();
      if (songInfo != null){
        yield SongLoaded(songInfo: songInfo);
      }
      else {
        await Future.delayed(Duration(seconds: 5));
        yield SongEmpty();
      }
    }
    else if (event is UpdateSong) {
      yield SongLoaded(songInfo: event.songInfo);
    }
  }
}