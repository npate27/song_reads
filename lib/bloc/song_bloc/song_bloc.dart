//https://medium.com/flutter-community/flutter-essential-what-you-need-to-know-567ad25dcd8f
//https://medium.com/flutter-community/flutter-todos-tutorial-with-flutter-bloc-d9dd833f9df3
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:song_reads/bloc/blocs.dart';
import 'package:song_reads/models/models.dart';
import 'package:song_reads/repositories/spotify_repository.dart';
import 'package:song_reads/utils/auth_utils.dart';


class SongBloc extends Bloc<SongEvent, SongState> {
  final SpotifyRepository spotifyRepository;

  SongBloc({@required this.spotifyRepository}) : assert(spotifyRepository != null), super(SongInit());

  @override
  Stream<SongState> mapEventToState(SongEvent event) async*{
    if (event is FindCurrentlyPlayingSpotifySong) {
      List<Object> currentSongResults = await spotifyRepository.getCurrentlyPlayingSong();
      //TODO: temporary to avoid hitting api limits, remove
      //Check if user is logged in
      if(currentSongResults == null) {
        yield SongDiscovery(isLoggedIn: false);
      }
      else {
        if(currentSongResults.isEmpty) {
          //Could be an advert or spotify is not open, wait before requerying
          //wait the standard 30 seconds if ad, otherwise user can refresh manually
          await Future.delayed(Duration(seconds: 30));
          yield SongDiscovery(isLoggedIn: true);
        } else {
          //Parse song and indicate time till next song takes over
          SongInfo songInfo = currentSongResults[0];
          int delayNextCurrentSongQueryMs = currentSongResults[1];
          yield SongLoaded(songInfo: songInfo, delayNextQueryMs: delayNextCurrentSongQueryMs);
        }
      }
    }
    else if (event is UpdateSong) {
      yield SongLoaded(songInfo: event.songInfo, delayNextQueryMs: null);
    }
    else if (event is SongLoginCheck) {
      bool isLoggedIn = isUserLoggedIn();
      yield(SongDiscovery(isLoggedIn: isLoggedIn));
    }
  }
}