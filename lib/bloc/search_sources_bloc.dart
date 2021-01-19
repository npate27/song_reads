//https://medium.com/flutter-community/flutter-essential-what-you-need-to-know-567ad25dcd8f
//https://medium.com/flutter-community/flutter-todos-tutorial-with-flutter-bloc-d9dd833f9df3
import 'package:bloc/bloc.dart';
import 'package:song_reads/repositories/repositories.dart';
import 'package:song_reads/bloc/blocs.dart';
import 'package:song_reads/models/models.dart';

class SearchSourceBloc extends Bloc<SearchEvent, SearchState> {
  final YouTubeRepository ytRepository;
  final RedditRepository redditRepository;
  // final GeniusRepository geniusRepository;

  SearchSourceBloc({this.ytRepository, this.redditRepository}) : super(SearchEmpty());

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is FetchSources) {
      yield SearchLoading();
      try {
        //TODO: Make these lists of top N results to be merged into one list (random order? allow filtering?)
        final YoutubeVideo ytVideo = await ytRepository.searchSong(event.title, event.artist);
        final RedditThread redditThread = await redditRepository.searchSong(event.title, event.artist);
        List<Source> results = [ytVideo, redditThread];
        yield SearchLoaded(results: results);
      } catch (_) {
        yield SearchError();
      }
    }
  }
}