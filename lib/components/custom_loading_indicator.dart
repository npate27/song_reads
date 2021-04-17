//https://blog.rive.app/rives-flutter-runtime-part-1/
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class CustomLoadingIndicator extends StatefulWidget {
  @override
  _CustomLoadingIndicatorState createState() => _CustomLoadingIndicatorState();
}

class _CustomLoadingIndicatorState extends State<CustomLoadingIndicator> {
  Artboard _artboard;

  @override
  void initState() {
    _loadRiveFile();
    super.initState();
  }

  // loads a Rive file
  void _loadRiveFile() async {
    final bytes = await rootBundle.load('assets/animations/song_reads_loading.riv');
    final file = RiveFile.import(bytes);
    if (file != null) {
      // Select an animation by its name
      setState(() => _artboard = file.mainArtboard
        ..addController(
          SimpleAnimation('Loading'),
        ));
    }
  }
  /// Show the rive file, when loaded
  @override
  Widget build(BuildContext context) {
    if(_artboard != null) {
      return Container(
        child: Rive(artboard: _artboard, fit: BoxFit.cover),
        height: 275,
        width: 350,
      );
    } else {
      return CircularProgressIndicator();
    }
  }
}
