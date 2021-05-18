import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ColorRevealState {}

class InitialColorRevealState extends ColorRevealState {}

class ChangeColorRevealState extends ColorRevealState {
  final Color color;

  ChangeColorRevealState({this.color});
}