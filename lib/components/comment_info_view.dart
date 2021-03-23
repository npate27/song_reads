import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:song_reads/models/models.dart';


class CommentInfoView extends StatelessWidget {
  final CommentInfo commentInfo;

  CommentInfoView({this.commentInfo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 10),
      child: IntrinsicHeight(
        child: Container(
          decoration: BoxDecoration(color: Colors.red, border: Border.all(color: Colors.black)),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Html(data: commentInfo.text),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Icon(Icons.person, size: 15.0),
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Text(commentInfo.user),
                            ),
                            Spacer(),
                            Icon(Icons.thumb_up, size: 15.0,),
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              //TODO: this is showing as null for YT vids, fix
                              child: Text(NumberFormat.compact().format(commentInfo.likes)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}