import 'dart:async';
import 'package:meta/meta.dart';
import 'package:song_reads/models/reddit_thread_model.dart';
import 'package:song_reads/clients/reddit_api_client.dart';
import 'package:song_reads/repositories/repository.dart';

class RedditRepository implements Repository {
  @override
  final RedditApiClient apiClient;

  RedditRepository({@required this.apiClient}) : assert(apiClient != null);

  Future<RedditThread> searchSong(String title, String artist) async {
    return await apiClient.searchSong(title, artist);
  }

  @override
  Future<void> getSongComments() {
    // TODO: implement getSongComments
    throw UnimplementedError();
  }
}