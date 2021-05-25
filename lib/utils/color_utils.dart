import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tinycolor/tinycolor.dart';

Color absoluteContrastColorFromLuminance(Color color) {
  return color.luminance > 0.5 ? Colors.black : Colors.white;
}

Color lightAdjustedComplimentColor(Color dominantColor) {
  Color complimentColor = dominantColor.compliment;
  if(dominantColor == Colors.white) {
    return Colors.black;
  }
  if(dominantColor == Colors.black) {
    return Colors.white;
  }
  if(complimentColor.isLight && dominantColor.isLight) {
    if(complimentColor == dominantColor) {
      return complimentColor.darken(80);
    }
    return complimentColor.darken(50);
  }
  if(complimentColor.isDark && dominantColor.isDark) {
    if(complimentColor == dominantColor) {
      return complimentColor.lighten(80);
    }
    return complimentColor.lighten(50);
  }
  return complimentColor;
}