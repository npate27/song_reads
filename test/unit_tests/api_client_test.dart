import 'package:mockito/mockito.dart';
import 'package:song_reads/clients/clients.dart';
import 'package:song_reads/models/models.dart';
import 'dart:convert';
import 'package:song_reads/constants/enums.dart';
import 'package:http/http.dart' as http;
import 'package:song_reads/constants/literals.dart' as LiteralConstants;
import '../resources/mock_api_response_literals.dart' as ApiConstants;
import 'package:flutter_test/flutter_test.dart';

class MockYouTubeApiClient extends Mock implements YouTubeApiClient {
  YouTubeApiClient _real;
  MockYouTubeApiClient(http.Client httpClient) {
    _real = YouTubeApiClient(httpClient: httpClient);
    when(searchSong(any, any, any)).thenAnswer((_) => _real.searchSong('HUMBLE.', 'Kendrick Lamar'));
  }
}

class MockRedditApiClient extends Mock implements RedditApiClient {
  RedditApiClient _real;
  MockRedditApiClient(http.Client httpClient) {
    _real = RedditApiClient(httpClient: httpClient);
    when(searchSong(any, any, any)).thenAnswer((_) =>  _real.searchSong('HUMBLE.', 'Kendrick Lamar'));
  }
}

class MockHttpClient extends Mock implements http.Client {}
//TODO: make this test more dynamic as more types of clients are added
main() {
  MockHttpClient mockHttpClient;
  // Needed to make sure loadSecret in YoutubeApiClient works properly
  //TODO: find a way to mock loadSecret in constructor for YoutubeApiClient
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    mockHttpClient = MockHttpClient();
  });

  group('YouTubeApiClient', () {
    MockYouTubeApiClient mockYouTubeApiClient;

    setUp(() {
      mockYouTubeApiClient = MockYouTubeApiClient(mockHttpClient);
    });

    test('should assert if null', () {
      expect(
            () => YouTubeApiClient(httpClient: null),
        throwsA(isAssertionError),
      );
    });

    group('searchSong', () {

      test('return List of RedditThread objects if http call successfully', () async {
        final List<dynamic> mockVideoResult = CommentSource.youtube.resultsFromResponse(jsonDecode(ApiConstants.youtubeApiSearchSongMultiResults), 5);
        final List<Future<YouTubeVideo>> mockResult = mockVideoResult.map((mockResult) async {
          final Map<String,dynamic> videoStats = await jsonDecode(ApiConstants.youtubeApiGetVideoStatsResult)['items'][0];
          mockResult.addAll(videoStats);
          return YouTubeVideo.fromJson(mockResult);
        }).toList();
        final List<YouTubeVideo> mockYouTubeVideoList =  await Future.wait(mockResult);

        when(mockHttpClient.get(startsWith('${LiteralConstants.baseYoutubeApiUrl}/search')))
            .thenAnswer((_) async => Future.value(http.Response(ApiConstants.youtubeApiSearchSongMultiResults, 200)));
        when(mockHttpClient.get(startsWith('${LiteralConstants.baseYoutubeApiUrl}/videos')))
            .thenAnswer((_) async => Future.value(http.Response(ApiConstants.youtubeApiGetVideoStatsResult, 200)));

        expect(await mockYouTubeApiClient.searchSong('title', 'artist', 5), mockYouTubeVideoList);
      });

      test('return Exception if http call error', () async {
        when(mockHttpClient.get(startsWith(LiteralConstants.baseYoutubeApiUrl)))
            .thenAnswer((_) async => Future.value(http.Response('{"error": "unauthorized"}', 404)));
        expect(mockYouTubeApiClient.searchSong("title", "artist", 5), throwsException);
      });
    });
  });

  group('RedditApiClient', () {
    MockRedditApiClient mockRedditApiClient;

    setUp(() {
      mockRedditApiClient = MockRedditApiClient(mockHttpClient);
    });

    test('should assert if null', () {
      expect(
            () => RedditApiClient(httpClient: null),
        throwsA(isAssertionError),
      );
    });

    group('searchSong', () {

      test('return List of RedditThread objects if http call successfully', () async{

        final List<dynamic> mockThreadResult = CommentSource.reddit.resultsFromResponse(jsonDecode(ApiConstants.redditApiSearchSongMultiResults), 5);
        final List<RedditThread> mockRedditThreadList =  mockThreadResult.map((mockResult) => RedditThread.fromJson(mockResult['data'])).toList();

        when(mockHttpClient.get(startsWith(LiteralConstants.baseRedditApiUrl)))
            .thenAnswer((_) async => Future.value(http.Response(ApiConstants.redditApiSearchSongMultiResults, 200)));

        expect(await mockRedditApiClient.searchSong('title', 'artist', 5), mockRedditThreadList);
      });

      test('return Exception if http call error', () async {
        when(mockHttpClient.get(startsWith(LiteralConstants.baseRedditApiUrl)))
            .thenAnswer((_) async => Future.value(http.Response('{"error": "unauthorized"}', 404)));
        expect(mockRedditApiClient.searchSong("title", "artist", 5), throwsException);
      });
    });
  });
}