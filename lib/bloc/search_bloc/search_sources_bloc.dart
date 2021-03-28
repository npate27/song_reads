//https://medium.com/flutter-community/flutter-essential-what-you-need-to-know-567ad25dcd8f
//https://medium.com/flutter-community/flutter-todos-tutorial-with-flutter-bloc-d9dd833f9df3
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:song_reads/constants/enums.dart';
import 'package:song_reads/models/comment_info.dart';
import 'package:song_reads/repositories/repositories.dart';
import 'package:song_reads/bloc/blocs.dart';
import 'package:song_reads/models/models.dart';
import 'package:song_reads/utils/preferences.dart';

class SearchSourceBloc extends Bloc<SearchEvent, SearchState> {
  final YouTubeRepository ytRepository;
  final RedditRepository redditRepository;
  // final GeniusRepository geniusRepository;

  SearchSourceBloc({@required this.ytRepository, @required this.redditRepository}) : assert(ytRepository != null && redditRepository != null), super(SearchEmpty());


  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async*{
    if (event is FetchSources) {
      yield SearchLoading();
      try {
        //TODO: Make these lists of top N results to be merged into one list (random order? allow filtering?)
        Preferences preferences = await Preferences.instance;
        final int maxResults = preferences.maxResultsPref();
        final List<Source> ytVideos = await ytRepository.searchSong(event.title, event.artist, maxResults);
        final List<Source> redditThreads = await redditRepository.searchSong(event.title, event.artist, maxResults);
        List<Source> results = [...ytVideos, ...redditThreads];
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
          // TODO: Handle this case.
            break;
        }
        yield SearchCommentsLoaded(results: results);
      } catch (_) { // TODO: More explicit exception
        yield SearchError();
      }
    }
  }
}