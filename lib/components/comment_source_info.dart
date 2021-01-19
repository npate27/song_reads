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

  //explicit downcast to get SourceModel descendant-specific member vars
  switch(sourceData.commentSource) {
    case CommentSource.youtube:
      var source = (sourceData as YoutubeVideo);
      title = source.title;
      uploadDetails = source.channelTitle;
      commentsCount = source.numComments.toString();
      likes = source.likes.toString() + '%';
      break;
    case CommentSource.reddit:
      var source = (sourceData as RedditThread);
      title = source.title;
      uploadDetails = '/r/${source.subreddit} - ${source.author}';
      commentsCount = source.numComments.toString();
      likes = source.likes.toString();
      break;
      //TODO: Handle this case where not all fields are non-null
    // case CommentSource.genius:
    //   var source = (sourceData as GeniusSong);
    //   title = source.title;
    //   uploadDetails = source.author;
    //   comments = source.numComments;
    //   likes = source.likes.toString();
    //   break;
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


