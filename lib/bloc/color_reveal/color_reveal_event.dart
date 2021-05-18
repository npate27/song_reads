import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ColorRevealEvent extends Equatable{
  const ColorRevealEvent();
}

class UpdateRevealColor extends ColorRevealEvent {
  final Color color;

  UpdateRevealColor({this.color});

  @override
  List<Object> get props => [];
}