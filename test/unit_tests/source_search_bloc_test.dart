
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:song_reads/bloc/blocs.dart';
import 'package:song_reads/models/models.dart';
import 'package:song_reads/repositories/repositories.dart';

class MockYoutubeRepository extends Mock implements YouTubeRepository {}
class MockRedditRepository extends Mock implements RedditRepository {}

void main() {

  SearchSourceBloc searchSourceBloc;
  MockYoutubeRepository mockYoutubeRepository;
  MockRedditRepository mockRedditRepository;

  setUp(() {
    mockYoutubeRepository = MockYoutubeRepository();
    mockRedditRepository = MockRedditRepository();
  });

  group('SearchSourceBloc', () {
    test('should assert if null', () {
      expect(
            () => SearchSourceBloc(ytRepository: null, redditRepository: null),
        throwsA(isAssertionError),
      );
    });

    test('initial state is correct', () {
      expect(SearchSourceBloc(ytRepository: mockYoutubeRepository, redditRepository: mockRedditRepository).state, SearchEmpty());
    });

    group('FetchSources', () {
      final List<YouTubeVideo> mockYoutubeResultList = [
        YouTubeVideo(id: '0', likes: 1234, title: '[Music Video] Artist - Song', channelTitle: 'ArtistVEVO', numComments: 1234),
        YouTubeVideo(id: '1', likes: 1234, title: '[Lyric Video] Artist - Song', channelTitle: 'ArtistVEVO', numComments: 1234),
      ];
      final List<RedditThread> mockRedditResultList = [
        RedditThread(id: '0', likes: 1234, title: '[FRESH] Artist - Song', subreddit: '/r/music', author: '/u/testuser', numComments: 1234),
        RedditThread(id: '1', likes: 1234, title: '[Discussion] Artist - Song', subreddit: '/r/music', author: '/u/testuser', numComments: 1234),
      ];

      setUp(() {
        searchSourceBloc = SearchSourceBloc(ytRepository: mockYoutubeRepository, redditRepository: mockRedditRepository);
      });

      tearDown(() {
        searchSourceBloc?.close();
      });

      blocTest(
        'emits [] when nothing is added',
        build: () => searchSourceBloc,
        expect: [],
      );

      //TODO: These should be emitting SearchEmpty as well no?
      blocTest(
          'emits [SearchLoading. SearchLoaded] when FetchSources is added and searchSong succeeds for all sources',
          build: () {
            when(mockYoutubeRepository.searchSong(any, any, any)).thenAnswer((_) async => mockYoutubeResultList);
            when(mockRedditRepository.searchSong(any, any, any)).thenAnswer((_) async => mockRedditResultList);
            return searchSourceBloc;
          },
          act: (bloc) => bloc.add(FetchSources(title: 'title', artist: 'artist')),
          expect: [SearchLoading(), SearchSourceLoaded(results: [...mockYoutubeResultList, ...mockRedditResultList])],
      );

      blocTest(
        'emits [SearchLoading. SearchError] when FetchSources is added and searchSong fails for at least one of the sources',
        build: () {
          when(mockYoutubeRepository.searchSong(any, any, any)).thenAnswer((_) async => mockYoutubeResultList);
          when(mockRedditRepository.searchSong(any, any, any)).thenThrow(Exception('dummy exception'));
          return searchSourceBloc;
        },
        act: (bloc) => bloc.add(FetchSources(title: 'title', artist: 'artist')),
        expect: [SearchLoading(), SearchError()],
      );
    });
  });
}