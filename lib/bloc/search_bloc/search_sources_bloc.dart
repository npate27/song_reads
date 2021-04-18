//https://medium.com/flutter-community/flutter-essential-what-you-need-to-know-567ad25dcd8f
//https://medium.com/flutter-community/flutter-todos-tutorial-with-flutter-bloc-d9dd833f9df3
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:song_reads/constants/enums.dart';
import 'package:song_reads/models/comment_info.dart';
import 'package:song_reads/repositories/repositories.dart';
import 'package:song_reads/bloc/blocs.dart';
import 'package:song_reads/models/models.dart';
import 'package:song_reads/utils/preferences_store.dart';

class SearchSourceBloc extends Bloc<SearchEvent, SearchState> {
  final YouTubeRepository ytRepository;
  final RedditRepository redditRepository;
  final GeniusRepository geniusRepository;

  SearchSourceBloc({@required this.ytRepository, @required this.redditRepository, @required this.geniusRepository}) : assert(ytRepository != null && redditRepository != null && geniusRepository != null), super(SearchEmpty());


  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async*{
    if (event is FetchSources) {
      yield SearchLoading();
      try {
        //TODO: Make these lists of top N results to be merged into one list (random order? allow filtering?)
        PreferencesStore preferences = PreferencesStore.instance;
        final int maxResults = preferences.maxResultsPref();
        SongInfo songInfo = event.songInfo;
        final Future<List<YouTubeVideo>> ytVideos = ytRepository.searchSong(songInfo.title, songInfo.artist, maxResults);
        final Future<List<RedditThread>> redditThreads = redditRepository.searchSong(songInfo.title, songInfo.artist, maxResults);
        //TODO: currently assumes top result is the desired one, needs more validation, like title validation
        final Future<List<GeniusSong>> geniusResult = geniusRepository.searchSong(songInfo.title, songInfo.artist, maxResults);
        final List<List<Source>> allResults = await Future.wait([geniusResult, ytVideos, redditThreads]);
        List<Source> results = allResults.expand((i) => i).toList();
        yield SearchSourceLoaded(results: results);
      } catch (_) { // TODO: More explicit exception
        yield SearchError();
      }
    }
    else if (event is FetchComments) {
      yield SearchLoading();
      try {
        List<CommentInfo> results;
        switch (event.source) {
          case CommentSource.youtube:
            results = await ytRepository.getSongComments(event.id);
            break;
          case CommentSource.reddit:
            results = await redditRepository.getSongComments(event.id);
            break;
          case CommentSource.genius:
            results = await geniusRepository.getSongComments(event.id);
            break;
        }
        yield SearchCommentsLoaded(results: results);
      } catch (_) { // TODO: More explicit exception
        yield SearchError();
      }
    }
  }
}