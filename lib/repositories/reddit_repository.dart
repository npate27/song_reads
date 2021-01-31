import 'dart:async';
import 'package:meta/meta.dart';
import 'package:song_reads/models/reddit_thread_model.dart';
import 'package:song_reads/models/models.dart';
import 'package:song_reads/clients/clients.dart';
import 'package:song_reads/repositories/repository.dart';

class RedditRepository implements Repository {
  @override
  final RedditApiClient apiClient;

  RedditRepository({@required this.apiClient}) : assert(apiClient != null);

  //TODO: max results shouldn't be optional here, only for Genius Repo and Genius API client
  Future<List<RedditThread>> searchSong(String title, String artist, [int maxResults]) async {
    return await apiClient.searchSong(title, artist, maxResults);
  }

  @override
  Future<void> getSongComments() {
    // TODO: implement getSongComments
    throw UnimplementedError();
  }
}