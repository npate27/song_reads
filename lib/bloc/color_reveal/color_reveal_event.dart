import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

abstract class ColorRevealEvent extends Equatable{
  const ColorRevealEvent();
}

class UpdateRevealColor extends ColorRevealEvent {
  final PaletteGenerator colorPalettes;

  UpdateRevealColor({this.colorPalettes});

  @override
  List<Object> get props => [];
}