import 'dart:async';
import 'package:meta/meta.dart';
import 'package:song_reads/models/genius_song_model.dart';
import 'package:song_reads/models/models.dart';
import 'package:song_reads/clients/clients.dart';
import 'package:song_reads/repositories/repository.dart';

class GeniusRepository implements Repository {
  final GeniusApiClient apiClient;

  GeniusRepository({@required this.apiClient}) : assert(apiClient != null);

  @override
  Future<List<GeniusSong>> searchSong(String title, String artist, [int maxResults]) async {
    return await apiClient.searchSong(title, artist);
  }

  //TODO: This API is not exposed, may need to set up a proxy API in APIGW that will scrape and return json of comments. Or hack it with headless web scraping...on mobile
  @override
  Future<void> getSongComments() {
    // TODO: implement getSongComments
    throw UnimplementedError();
  }
}