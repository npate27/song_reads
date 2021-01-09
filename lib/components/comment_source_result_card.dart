import 'package:flutter/material.dart';
import 'package:song_reads/components/comment_source_info.dart';
import 'package:song_reads/constants/enums.dart';

class CommentSourceResult extends StatelessWidget {
  final CommentSource sourceType;
  final String title;
  //TODO: Make this an object
  final String sourceData;

  CommentSourceResult({Key key, this.sourceType, this.title, this.sourceData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10,10,10,0),
      height: 100,
      width: double.maxFinite,
      child: Card(
        elevation: 5,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Image.asset(sourceType.sourceImagePath),
                  ),
                  CommentSourceInfo(sourceType: sourceType,)
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Icon(Icons.arrow_forward_ios_sharp),
              )
            ]
        ),
      ),
    );
  }
}
