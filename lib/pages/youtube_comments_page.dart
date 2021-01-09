import 'package:flutter/material.dart';
import 'package:song_reads/constants/routes.dart' as RouterConstants;

class YoutubeComments extends StatefulWidget {
  YoutubeComments({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<YoutubeComments> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Test',
            ),
          ],
        ),
      ),
    );
  }
}
