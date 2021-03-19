import 'package:flutter/material.dart';
import 'package:song_reads/components/comment_source_info.dart';
import 'package:song_reads/constants/enums.dart';
import 'package:song_reads/constants/routes.dart' as RouterConstants;
import 'package:song_reads/models/models.dart';

class CommentSourceResultCardItem extends StatelessWidget {
  final Source sourceData;

  CommentSourceResultCardItem({this.sourceData});

  @override
  Widget build(BuildContext context) {
    CommentSource commentSource = sourceData.commentSource;
    return InkWell(
      onTap: () { Navigator.pushNamed(context, RouterConstants.commentsRoute, arguments: sourceData); },
      child: Container(
        padding: EdgeInsets.fromLTRB(10,10,10,0),
        height: 100,
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
        ),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: [0.25, 1],
                  colors: [commentSource.sourceImageBaseColor, commentSource.sourceImageBaseColor.withOpacity(0.35)],
                )
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Image.asset(commentSource.sourceImagePath),
                            ),
                            //TODO: There's gotta be a better way of doing this surely
                            Flexible(child: Container(child: CommentSourceInfo(sourceData: sourceData,)))
                          ],
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Icon(Icons.arrow_forward_ios_sharp, color: Colors.white,),
                    ),
                  )
                ]
            ),
          ),
        ),
      ),
    );
  }
}