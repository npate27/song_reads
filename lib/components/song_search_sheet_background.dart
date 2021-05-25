import 'dart:math';

import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:song_reads/bloc/blocs.dart';
import 'package:song_reads/components/song_search_sheet.dart';
import 'package:song_reads/utils/color_utils.dart';

class SongSearchSheetBackground extends StatefulWidget {
  const SongSearchSheetBackground({Key key}) : super(key: key);

  @override
  _SongSearchSheetBackgroundState createState() => _SongSearchSheetBackgroundState();
}

class _SongSearchSheetBackgroundState extends State<SongSearchSheetBackground> with SingleTickerProviderStateMixin{
  AnimationController animationController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        colorRevealBuilder(),
        SongSearchSheet()
      ],
    );
  }

  BlocBuilder<ColorRevealBloc, ColorRevealState> colorRevealBuilder() {
    Color previousColor;
    Color revealColor;
    return BlocBuilder<ColorRevealBloc, ColorRevealState>(
        builder: (context, state) {
          if (state is InitialColorRevealState) {
            previousColor = Colors.transparent;
            revealColor = Colors.transparent;
          }
          if (state is ChangeColorRevealState) {
            if (previousColor != revealColor) {
              animationController.reset();
            }
            previousColor = revealColor;
            revealColor = lightAdjustedComplimentColor(state.colorPalettes.dominantColor.color);
          }
          Future.delayed(const Duration(milliseconds: 100), () {
            animationController.forward();
          });

          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Stack(
                children: [
                  Container(decoration: BoxDecoration(
                      color: previousColor,
                      borderRadius: BorderRadius.all(Radius.circular(15.0))
                  )),
                  CircularRevealAnimation(
                    child: SizedBox.expand(
                        child: Container(decoration: BoxDecoration(
                            color: revealColor,
                            borderRadius: BorderRadius.all(Radius.circular(
                                15.0))
                        ))),
                    //TODO: Do this better. Currently really rough calculations based on padding/img values
                    centerOffset: Offset(
                        constraints.maxWidth, constraints.maxHeight),
                    animation: animation,
                    minRadius: 100,
                    maxRadius: sqrt(pow(constraints.maxWidth, 2) +
                        pow(constraints.maxHeight, 2)) + 500,
                  )
                ],
              );
            },
          );
        }
    );
  }
}
