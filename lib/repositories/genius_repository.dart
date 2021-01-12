import 'dart:async';
import 'package:meta/meta.dart';
import 'package:song_reads/repositories/api_client.dart';
import 'package:song_reads/repositories/genius_api_client.dart';
import 'package:song_reads/repositories/repository.dart';

class GeniusRepository implements Repository {
  final GeniusApiClient apiClient;

  GeniusRepository({@required this.apiClient}) : assert(apiClient != null);

  Future<void> searchSong(String title, String artist) async {
    return await apiClient.searchSong(title, artist);
  }

  @override
  Future<void> getSongComments() {
    // TODO: implement getSongComments
    throw UnimplementedError();
  }
}