import 'package:flutter/material.dart';
import 'package:song_reads/constants/enums.dart';

class CommentSourceInfo extends StatelessWidget {
  final CommentSource sourceType;

  CommentSourceInfo({Key key, this.sourceType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Song Name - Artist" + sourceType.formattedTitle),
        Text('Temp Artist'),
        Text('Temp Album'),
        Row(
          children: [
            Icon(Icons.mode_comment_sharp, size: 15.0,),
            Text('1234'),
            SizedBox(width: 10.0,),
            Icon(Icons.thumb_up, size: 15.0,),
            Text('1234'),
          ],
        )
      ],
    );
  }
}
