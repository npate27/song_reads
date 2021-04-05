import 'dart:async';
import 'package:meta/meta.dart';
import 'package:song_reads/models/models.dart';
import 'package:song_reads/clients/clients.dart';

class SpotifyRepository {
  final SpotifyApiClient apiClient;

  SpotifyRepository({@required this.apiClient}) : assert(apiClient != null);

  Future<String> getAccessToken() async {
    return await apiClient.getAccessToken();
  }

  Future<List<Object>> getCurrentlyPlayingSong() async{
    return await apiClient.getCurrentlyPlayingSong();
  }

  Future<List<SongInfo>> getSongSearchResults(String query, [String accessToken]) async {
    if(accessToken == null) {
      return await apiClient.getSongSearchResults(query);
    }
    else {
      return await apiClient.getSongSearchResults(query, accessToken);
    }
  }
}