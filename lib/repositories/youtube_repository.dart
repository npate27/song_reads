import 'dart:async';
import 'package:meta/meta.dart';
import 'package:song_reads/repositories/repository.dart';
import 'package:song_reads/models/models.dart';
import 'package:song_reads/clients/clients.dart';

class YouTubeRepository implements Repository {
  @override
  final YouTubeApiClient apiClient;

  YouTubeRepository({@required this.apiClient}) : assert(apiClient != null);

  //TODO: max results shouldn't be optional here, only for Genius Repo and Genius API client
  Future<List<YouTubeVideo>> searchSong(String title, String artist, [int maxResults]) async {
    return await apiClient.searchSong(title, artist, maxResults);
  }

  @override
  Future<void> getSongComments() {
    // TODO: implement getSongComments
    throw UnimplementedError();
  }
}