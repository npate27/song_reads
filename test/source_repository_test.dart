import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:song_reads/clients/clients.dart';
import 'package:song_reads/repositories/repositories.dart';

class MockYouTubeApiClient extends Mock implements YouTubeApiClient {}
class MockRedditApiClient extends Mock implements RedditApiClient {}

void main() {
  group('assertion', () {
    test('should assert if null for YoutubeRepository', () {
      expect(
            () => YouTubeRepository(apiClient: null),
        throwsA(isAssertionError),
      );
    });
    test('should assert if null for RedditRepository', () {
      expect(
            () => RedditRepository(apiClient: null),
        throwsA(isAssertionError),
      );
    });
  });

  group('searchSong', () {
      final YouTubeRepository youTubeRepository = YouTubeRepository(apiClient: MockYouTubeApiClient());
      final RedditRepository redditRepository = RedditRepository(apiClient: MockRedditApiClient());

      test('should called searchSong from YouTubeApiClient', () async{
        when(youTubeRepository.searchSong(any, any, any)).thenAnswer((_) => Future.value());
        youTubeRepository.searchSong('title', 'artist', 5);
        verify(youTubeRepository.searchSong(any, any, any)).called(1);
      });

      test('should called searchSong from RedditApiClient', () async{
        when(redditRepository.searchSong(any, any, any)).thenAnswer((_) => Future.value());
        redditRepository.searchSong('title', 'artist', 5);
        verify(redditRepository.searchSong(any, any, any)).called(1);
      });
  });

}