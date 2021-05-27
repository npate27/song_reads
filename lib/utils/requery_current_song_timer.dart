import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:song_reads/bloc/blocs.dart';

class ReQueryCurrentSongTimer{
  static final ReQueryCurrentSongTimer _instance = ReQueryCurrentSongTimer._internal();
  Timer _delayNextQueryTimer;

  ReQueryCurrentSongTimer._internal() {
    this._delayNextQueryTimer = Timer(Duration(milliseconds: 0), () => {});
  }

  factory ReQueryCurrentSongTimer() {
    return _instance;
  }

  void cancel() {
    _delayNextQueryTimer.cancel();
  }
  void updateTimerDuration(int millisecondDuration, BuildContext context) {
    if(_delayNextQueryTimer.isActive) {
      _delayNextQueryTimer.cancel();
    }
    _delayNextQueryTimer = Timer(Duration(milliseconds: millisecondDuration), () => {
      //TODO handle ads
      BlocProvider.of<SongBloc>(context).add(FindCurrentlyPlayingSpotifySong())
    });
  }
}