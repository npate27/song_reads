import 'dart:async';
import 'package:meta/meta.dart';
import 'package:song_reads/repositories/repository.dart';
import 'package:song_reads/repositories/youtube_api_client.dart';

class YouTubeRepository implements Repository {
  @override
  final YouTubeApiClient apiClient;

  YouTubeRepository({@required this.apiClient}) : assert(apiClient != null);

  Future<void> searchSong(String title, String artist) async {
    return await apiClient.searchSong(title, artist);
  }

  @override
  Future<void> getSongComments() {
    // TODO: implement getSongComments
    throw UnimplementedError();
  }
}