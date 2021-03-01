import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:song_reads/constants/enums.dart';
import 'package:song_reads/constants/literals.dart' as LiteralConstants;
import 'package:song_reads/models/models.dart';
import 'package:song_reads/clients/api_client.dart';
import 'package:song_reads/utils/api_utils.dart';
import 'package:song_reads/utils/secrets_utils.dart';

class YouTubeApiClient extends ApiClient {
  final http.Client httpClient;
  Future<String> apiKey;
  static const CommentSource sourceType = CommentSource.youtube;

  YouTubeApiClient({@required this.httpClient,}) : assert(httpClient != null) {
    apiKey = loadSecretFromKey('youtube_api_key');
  }

  @override
  Future<List<YouTubeVideo>> searchSong(String title, String artist, [int maxResults]) async {
    final String key = await apiKey;
    final String query = '$title $artist';
    //TODO: use authorization header for key
    //part=snippet gives more info to parse and verify, id just gives
    final String uri = '${LiteralConstants.baseYoutubeApiUrl}/search?part=snippet&q=$query&key=$key';
    final uriEncoded = Uri.encodeFull(uri);
    final response = parseResponse(await httpClient.get(uriEncoded));
    //TODO: check if hits is empty in api client before passing this over
    final List<dynamic> videoResult = sourceType.resultsFromResponse(response, false, maxResults);
    final List<Future<YouTubeVideo>> result = videoResult.map((result) async {
      final String videoId = result['id']['videoId'];
      final Map<String,dynamic> videoStats = await getVideoStats(videoId, key);
      result.addAll(videoStats);
      return YouTubeVideo.fromJson(result);
    }).toList();
    return Future.wait(result);
  }

  Future<Map<String,dynamic>> getVideoStats(String videoId, String key) async {
    final String uri = '${LiteralConstants.baseYoutubeApiUrl}/videos?part=statistics&id=$videoId&key=$key';
    final uriEncoded = Uri.encodeFull(uri);
    final response = parseResponse(await httpClient.get(uriEncoded));
    //TODO: handle no results here. is that necessary?
    return response['items'][0];
  }

  @override
  Future<List<CommentInfo>> getSongComments(String id) async {
    final String key = await apiKey;
    final String uri = '${LiteralConstants.baseYoutubeApiUrl}/commentThreads?part=snippet&videoId=$id&maxResults=100&order=relevance&key=$key';
    final uriEncoded = Uri.encodeFull(uri);
    final response = parseResponse(await httpClient.get(uriEncoded));
    final List<dynamic> commentResult = sourceType.resultsFromResponse(response, true);
    final List<CommentInfo> result = commentResult.map((result) => CommentInfo.fromJson(result, sourceType)).toList();
    return result;
  }
}