//https://medium.com/flutter-community/flutter-essential-what-you-need-to-know-567ad25dcd8f
//https://medium.com/flutter-community/flutter-todos-tutorial-with-flutter-bloc-d9dd833f9df3
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:song_reads/constants/enums.dart';
import 'package:song_reads/models/comment_info.dart';
import 'package:song_reads/repositories/repositories.dart';
import 'package:song_reads/bloc/blocs.dart';
import 'package:song_reads/models/models.dart';
import 'package:song_reads/utils/preferences_store.dart';
import 'package:song_reads/constants/literals.dart' as LiteralConstants;

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
        //Get Song Results
        final Future<List<YouTubeVideo>> ytVideosSongs = ytRepository.searchSong(songInfo.title, songInfo.artist, maxResults);
        final Future<List<RedditThread>> redditThreadsSongs = redditRepository.searchSong(songInfo.title, songInfo.artist, maxResults);
        //TODO: currently assumes top result is the desired one, needs more validation, like title validation
        final Future<List<GeniusSong>> geniusResultSongs = geniusRepository.searchSong(songInfo.title, songInfo.artist, maxResults);
        final List<List<Source>> allSongResults = await Future.wait([geniusResultSongs, ytVideosSongs, redditThreadsSongs]);
        List<Source> songResults = allSongResults.expand((i) => i).toList();

        // //Get Album Results
        List<Source> albumResults;
        if(songInfo.album != event.currentAlbum) {
          final Future<List<YouTubeVideo>> ytVideosAlbums = ytRepository.searchSong(songInfo.album, songInfo.artist, maxResults);
          final Future<List<RedditThread>> redditThreadsAlbums = redditRepository.searchSong(songInfo.album, songInfo.artist, maxResults);
          //TODO: currently assumes top result is the desired one, needs more validation, like title validation
          final Future<List<GeniusSong>> geniusResultAlbums = geniusRepository.searchSong(songInfo.album, songInfo.artist, maxResults);
          final List<List<Source>> allAlbumResults = await Future.wait([geniusResultAlbums, ytVideosAlbums, redditThreadsAlbums]);
          albumResults = allAlbumResults.expand((i) => i).toList();
        }

        yield SearchSourceLoaded(songResults: songResults, albumResults: albumResults);
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