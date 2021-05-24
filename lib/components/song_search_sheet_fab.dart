import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:song_reads/bloc/blocs.dart';
import 'package:song_reads/components/song_search_sheet.dart';
import 'package:song_reads/components/song_search_sheet_background.dart';
import 'package:song_reads/constants/routes.dart' as RouterConstants;
import 'package:song_reads/constants/literals.dart' as LiteralConstants;
import 'package:tinycolor/tinycolor.dart';

class SongSearchSheetFab extends StatefulWidget {
  const SongSearchSheetFab({Key key}) : super(key: key);

  @override
  _SongSearchSheetFabState createState() => _SongSearchSheetFabState();
}

class _SongSearchSheetFabState extends State<SongSearchSheetFab> {
  //TODO: make this default be better, depends on default background color, currently grey.
  Color dominantColor = Colors.white;
  Color complementaryColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ColorRevealBloc, ColorRevealState>(
      listener: (BuildContext context, ColorRevealState state) {
        if (state is ChangeColorRevealState) {
          setState(() {
            dominantColor = state.colorPalettes.dominantColor.color;
            complementaryColor = dominantColor.compliment;
          });
        }
      },
      child: FloatingActionButton(
        onPressed: () async {
          showModalBottomSheet(
              isScrollControlled: false,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              backgroundColor: dominantColor,
              context: context,
              builder: (context) => SongSearchSheetBackground()
          );
        },
        child: Icon(Icons.search, color: dominantColor),
        backgroundColor: complementaryColor.isDark ? complementaryColor.lighten() : complementaryColor.darken(),
      ),
    );
  }
}
