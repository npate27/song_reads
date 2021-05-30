import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:song_reads/bloc/blocs.dart';
import 'package:song_reads/components/song_search_sheet.dart';
import 'package:song_reads/constants/routes.dart' as RouterConstants;
import 'package:song_reads/constants/literals.dart' as LiteralConstants;
import 'package:song_reads/utils/color_utils.dart';
import 'dart:math';

import 'package:song_reads/utils/requery_current_song_timer.dart';

class MainFabs extends StatefulWidget {
  const MainFabs({Key key}) : super(key: key);

  @override
  _MainFabsState createState() => _MainFabsState();
}

class _MainFabsState extends State<MainFabs> with SingleTickerProviderStateMixin{
  //TODO: make this default be better, depends on default background color, currently grey.
  Color dominantColor = Colors.white;
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
    return BlocListener<ColorRevealBloc, ColorRevealState>(
      listener: (BuildContext context, ColorRevealState state) {
        if (state is ChangeColorRevealState) {
          setState(() {
            dominantColor = state.colorPalettes.dominantColor.color;
          });
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              animationController.repeat();
              ReQueryCurrentSongTimer().cancel();
              BlocProvider.of<SongBloc>(context).add(FindCurrentlyPlayingSpotifySong());
              BlocProvider.of<SongBloc>(context).listen((state) {
                animationController.reset();
              });
            },
            child: AnimatedBuilder(
              animation: animation,
              child: Icon(Icons.refresh, color: dominantColor),
              builder: (BuildContext context, Widget child) {
                return Transform.rotate(
                  child: child,
                  angle: animation.value * 2.0 * pi,
                );
              }
            ),
            backgroundColor: absoluteContrastColorFromLuminance(dominantColor),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () async {
              showModalBottomSheet(
                  isScrollControlled: false,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  backgroundColor: dominantColor,
                  context: context,
                  builder: (context) => SongSearchSheet()
              );
            },
            child: Icon(Icons.search, color: dominantColor),
            backgroundColor: lightAdjustedComplimentColor(dominantColor),
          ),
        ],
      ),
    );
  }
}
