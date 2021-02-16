import 'package:flutter/material.dart';
import 'package:song_reads/constants/enums.dart';
import 'package:song_reads/models/models.dart';

class CommentSourceInfo extends StatelessWidget {
  final dynamic sourceData;

  CommentSourceInfo({this.sourceData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: sourceContentWidgets(sourceData),
    );
  }
}

List<Widget> sourceContentWidgets(dynamic sourceData) {
  String title;
  String uploadDetails;
  //TODO: format these two to be short if more than a thousand ("1K")
  String commentsCount;
  String likes;

  CommentSource commentSource = sourceData.commentSource;
  var source = commentSource.typeCastedSource(sourceData);
  switch(commentSource) {
    case CommentSource.youtube:
      title = source.title;
      uploadDetails = source.channelTitle;
      commentsCount = source.numComments.toString();
      likes = source.likes.toString() + '%';
      break;
    case CommentSource.reddit:
      title = source.title;
      uploadDetails = '/r/${source.subreddit} - ${source.author}';
      commentsCount = source.numComments.toString();
      likes = source.likes.toString();
      break;
    case CommentSource.genius:
        //TODO: Handle this case where not all fields are non-null
      break;
  }

  return [
    //TODO: Make this a Marquee (so it scrolls if too long)
    Text(title, overflow: TextOverflow.fade, softWrap: false,),
    Text(uploadDetails, overflow: TextOverflow.fade, softWrap: false,), //Channel or user that posted it
    Row(
      children: [
        Icon(Icons.mode_comment_sharp, size: 15.0),
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Text(commentsCount),
        ),
        SizedBox(width: 10.0,),
        Icon(Icons.thumb_up, size: 15.0,),
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Text(likes),
        ),
      ],
    )
  ];
}


