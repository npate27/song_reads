import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:song_reads/bloc/blocs.dart';
import 'package:song_reads/constants/routes.dart' as RouterConstants;
import 'package:song_reads/constants/literals.dart' as LiteralConstants;

class SongReadsMainHeader extends StatefulWidget {
  const SongReadsMainHeader({Key key}) : super(key: key);

  @override
  _SongReadsMainHeaderState createState() => _SongReadsMainHeaderState();
}

class _SongReadsMainHeaderState extends State<SongReadsMainHeader> {
  //TODO: make this default be better, depends on default background color, currently grey.
  Color contrastColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ColorRevealBloc, ColorRevealState>(
        listener: (BuildContext context, ColorRevealState state) {
          if (state is ChangeColorRevealState) {
             setState(() {
               contrastColor = state.colorPalettes.dominantColor.color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
             });
          }
        },
        child: Stack(
          children: [
            Align(
            alignment: Alignment.center,
              child: Text(
                  LiteralConstants.appName,
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, color: contrastColor)
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.settings, size: 30, color: contrastColor),
                onPressed: () { Navigator.pushNamed(context, RouterConstants.preferencesRoute); },
              ),
            ),
          ],
          ),
    );
  }
}
