import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

abstract class ColorRevealState {}

class InitialColorRevealState extends ColorRevealState {}

class ChangeColorRevealState extends ColorRevealState {
  final PaletteGenerator colorPalettes;

  ChangeColorRevealState({this.colorPalettes});
}