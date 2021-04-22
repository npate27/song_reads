import 'package:flutter/material.dart';
import 'package:song_reads/constants/routes.dart' as RouteConstants;
import 'package:song_reads/pages/comments_page.dart';
import 'package:song_reads/pages/main_page.dart';
import 'package:song_reads/pages/preferences_page.dart';

import 'models/source_model.dart';

/* Reference
https://medium.com/flutter-community/flutter-navigation-cheatsheet-a-guide-to-named-routing-dc642702b98c
*/

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteConstants.mainRoute:
        return MaterialPageRoute(builder: (_) => MainPage(), settings: settings);
      case RouteConstants.commentsRoute:
        return MaterialPageRoute(builder: (BuildContext context) {
          final Source sourceData = settings.arguments;
          return CommentsPage(sourceData: sourceData);
        }, settings: settings);
      case RouteConstants.preferencesRoute:
        return MaterialPageRoute(builder: (_) => PreferencesPage(), settings: settings);
      default:
        return MaterialPageRoute(builder: (_) => MainPage(), settings: settings);
    }
  }
}