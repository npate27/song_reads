//https://medium.com/flutter-community/flutter-essential-what-you-need-to-know-567ad25dcd8f
//https://medium.com/flutter-community/flutter-todos-tutorial-with-flutter-bloc-d9dd833f9df3
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:song_reads/constants/enums.dart';
import 'package:song_reads/models/comment_info.dart';
import 'package:song_reads/repositories/repositories.dart';
import 'package:song_reads/bloc/blocs.dart';
import 'package:song_reads/models/models.dart';
import 'package:song_reads/utils/preferences.dart';

class SongBloc extends Bloc<SongEvent, SongState> {
  SongBloc(): super(SongEmpty());


  @override
  Stream<SongState> mapEventToState(SongEvent event) async*{
    if (event is UpdateSong) {
      yield SongLoaded(songInfo: event.songInfo);
    }
  }
}