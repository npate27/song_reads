import 'package:flutter/material.dart';
import 'package:song_reads/components/comment_source_result_card.dart';
import 'package:song_reads/components/now_playing_card.dart';
import 'package:song_reads/components/section_header.dart';
import 'package:song_reads/constants/routes.dart' as RouterConstants;
import 'package:song_reads/constants/literals.dart' as LiteralConstants;
import 'package:song_reads/constants/enums.dart';


class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<MainPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                        LiteralConstants.appName,
                        style: TextStyle (fontSize: 30.0, fontWeight: FontWeight.bold)
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.settings, size: 30),
                  ),
                ],
              ),
              NowPlayingCard(),
              SectionHeader(sectionTitle: LiteralConstants.songCommentHeader,),
              //TODO: sourceData object containing source-specific info (likes, subreddit, etc.)
              CommentSourceResult(sourceType: CommentSource.genius, sourceData: null),
              CommentSourceResult(sourceType: CommentSource.youtube, sourceData: null),
              CommentSourceResult(sourceType: CommentSource.reddit, sourceData: null),
              SectionHeader(sectionTitle: LiteralConstants.albumCommentHeader,),
              CommentSourceResult(sourceType: CommentSource.genius, sourceData: null),
            ],
          ),
        ),
      ),
    );
  }


}
