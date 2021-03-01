import 'dart:async';
import 'package:meta/meta.dart';
import 'package:song_reads/models/reddit_thread_model.dart';
import 'package:song_reads/models/models.dart';
import 'package:song_reads/clients/clients.dart';

class SpotifyRepository {
  final SpotifyApiClient apiClient;

  SpotifyRepository({@required this.apiClient}) : assert(apiClient != null);

  Future<String> getAccessToken() async {
    return await apiClient.getAccessToken();
  }

  Future<List<SongInfo>> getSongSearchResults(String query) async {
    return await apiClient.getSongSearchResults(query);
  }
}