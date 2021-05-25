import 'package:flutter/material.dart' hide Router;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:song_reads/bloc/blocs.dart';
import 'package:song_reads/bloc/color_reveal/color_reveal_bloc.dart';
import 'package:song_reads/clients/clients.dart';
import 'package:song_reads/clients/http_client_singleton.dart';
import 'package:song_reads/repositories/reddit_repository.dart';
import 'package:song_reads/repositories/repositories.dart';
import 'package:song_reads/repositories/spotify_repository.dart';
import 'package:song_reads/router.dart';
import 'package:song_reads/constants/routes.dart' as RouterConstants;
import 'package:song_reads/constants/literals.dart' as LiteralConstants;
import 'package:flutter/rendering.dart';
import 'package:song_reads/utils/preferences_store.dart';
import 'package:song_reads/utils/token_store.dart';
import 'package:url_strategy/url_strategy.dart';

/// Custom [BlocObserver] which observes all bloc and cubit instances.
class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
  }

  @override
  void onChange(Cubit cubit, Change change) {
    super.onChange(cubit, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    super.onError(cubit, error, stackTrace);
  }
}

class SongReads extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SearchSourceBloc>(
          create: (BuildContext context) => SearchSourceBloc(
              ytRepository: YouTubeRepository(apiClient: YouTubeApiClient(httpClient: AppHttpClient().client)),
              redditRepository: RedditRepository(apiClient: RedditApiClient(httpClient: AppHttpClient().client)),
              geniusRepository: GeniusRepository(apiClient: GeniusApiClient(httpClient: AppHttpClient().client))),
        ),
        BlocProvider<SongBloc>(
          create: (BuildContext context) => SongBloc(spotifyRepository: SpotifyRepository(apiClient: SpotifyApiClient(httpClient: AppHttpClient().client)))
        ),
        BlocProvider<ColorRevealBloc>(
          create: (BuildContext context) => ColorRevealBloc()
        )
      ],
      child: MaterialApp(
          title: LiteralConstants.appName,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          onGenerateInitialRoutes: (initialRoute) => [Router.generateRoute(RouteSettings(name:initialRoute))],
          onGenerateRoute: Router.generateRoute,
          initialRoute: RouterConstants.mainRoute
      ),
    );
  }
}
void main() async {
  setPathUrlStrategy();
  Bloc.observer = SimpleBlocObserver();
  await Hive.initFlutter();
  await Hive.openBox(TokenStore.tokenBoxKey);
  await Hive.openBox(PreferencesStore.preferencesBoxKey);
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
  ));
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
  runApp(SongReads());
  debugPaintSizeEnabled = false;
}
