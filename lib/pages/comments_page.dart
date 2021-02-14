import 'package:flutter/material.dart';
import 'package:song_reads/constants/routes.dart' as RouterConstants;

class CommentsPage extends StatefulWidget {
  CommentsPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<CommentsPage> {

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
