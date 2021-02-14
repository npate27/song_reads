import 'package:flutter/material.dart';
import 'package:song_reads/constants/routes.dart' as RouteConstants;
import 'package:song_reads/pages/comments_page.dart';
import 'package:song_reads/pages/main_page.dart';
import 'package:song_reads/pages/preferences_page.dart';

/* Reference
https://medium.com/flutter-community/flutter-navigation-cheatsheet-a-guide-to-named-routing-dc642702b98c
*/

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteConstants.mainRoute:
        return MaterialPageRoute(builder: (_) => MainPage());
      case RouteConstants.commentsRoute:
        return MaterialPageRoute(builder: (_) => CommentsPage());
      case RouteConstants.preferencesRoute:
        return MaterialPageRoute(builder: (_) => PreferencesPage());
      default:
        return MaterialPageRoute(builder: (_) => MainPage());
    }
  }
}