import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:song_reads/bloc/blocs.dart';

class ColorRevealBloc extends Bloc<ColorRevealEvent, ColorRevealState> {
  ColorRevealBloc() : super(InitialColorRevealState());

  @override
  Stream<ColorRevealState> mapEventToState(ColorRevealEvent event) async* {
    if (event is UpdateRevealColor) {
      yield ChangeColorRevealState(color: event.color);
    }
  }
}
