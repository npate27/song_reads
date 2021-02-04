import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:song_reads/constants/enums.dart';
import 'package:song_reads/constants/literals.dart' as LiteralConstants;
import 'package:song_reads/models/models.dart';
import 'package:song_reads/clients/api_client.dart';
import 'package:song_reads/utils/secrets_utils.dart';

class YouTubeApiClient extends ApiClient {
  final http.Client httpClient;
  Future<String> apiKey;
  static const CommentSource sourceType = CommentSource.youtube;

  YouTubeApiClient({@required this.httpClient,}) : assert(httpClient != null) {
    apiKey = loadSecret(secretPath: 'assets/secrets.json', key: 'youtube_api_key');
  }

  @override
  Future<List<YoutubeVideo>> searchSong(String title, String artist, [int maxResults]) async{
    final String key = await apiKey;
    final String query = '$title $artist';
    //TODO: use authorization header for key
    //part=snippet gives more info to parse and verify, id just gives
    final String uri = '${LiteralConstants.baseYoutubeApiUrl}/search?part=snippet&q=$query&key=$key';
    final uriEncoded = Uri.encodeFull(uri);
    final response = parseResponse(await httpClient.get(uriEncoded));
    //TODO: check if hits is empty in api client before passing this over
    final List<dynamic> videoResult = sourceType.resultsFromResponse(response, maxResults);
    final List<Future<YoutubeVideo>> result = videoResult.map((result) async {
      final String videoId = result['id']['videoId'];
      final Map<String,dynamic> videoStats = await getVideoStats(videoId, key);
      result.addAll(videoStats);
      return YoutubeVideo.fromJson(result);
    }).toList();

    return Future.wait(result);
  }

  Future<Map<String,dynamic>> getVideoStats(String videoId, String key) async{
    final String uri = '${LiteralConstants.baseYoutubeApiUrl}/videos?part=statistics&id=$videoId&key=$key';
    final uriEncoded = Uri.encodeFull(uri);
    final response = parseResponse(await httpClient.get(uriEncoded));
    return response['items'][0];
  }

  @override
  Future<void> getSongComments() {
    // TODO: implement getSongComments
    throw UnimplementedError();
  }
}