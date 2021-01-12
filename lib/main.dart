import 'package:flutter/material.dart' hide Router;
import 'package:song_reads/router.dart';
import 'package:song_reads/constants/routes.dart' as RouterConstants;
import 'package:song_reads/constants/literals.dart' as LiteralConstants;
import 'package:flutter/rendering.dart';

void main() {
  runApp(SongReads());
  debugPaintSizeEnabled = false;
}

class SongReads extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: LiteralConstants.appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onGenerateRoute: Router.generateRoute,
      initialRoute: RouterConstants.mainRoute
    );
  }
}

