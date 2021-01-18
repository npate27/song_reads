import 'package:flutter/material.dart';
import 'package:song_reads/constants/routes.dart' as RouteConstants;
import 'package:song_reads/pages/genius_comments_page.dart';
import 'package:song_reads/pages/main_page.dart';
import 'package:song_reads/pages/reddit_comments_page.dart';
import 'package:song_reads/pages/youtube_comments_page.dart';

/* Reference
https://medium.com/flutter-community/flutter-navigation-cheatsheet-a-guide-to-named-routing-dc642702b98c
*/

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteConstants.mainRoute:
        return MaterialPageRoute(builder: (_) => MainPage());
      case RouteConstants.youtubeCommentsRoute:
        return MaterialPageRoute(builder: (_) => YoutubeComments());
      case RouteConstants.geniusCommentsRoute:
        return MaterialPageRoute(builder: (_) => GeniusComments());
      case RouteConstants.redditCommentsRoute:
        return MaterialPageRoute(builder: (_) => RedditComments());
      default:
        return MaterialPageRoute(builder: (_) => MainPage());
    }
  }
}