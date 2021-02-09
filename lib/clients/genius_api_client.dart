import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:song_reads/constants/enums.dart';
import 'package:song_reads/constants/literals.dart' as LiteralConstants;
import 'package:song_reads/models/models.dart';
import 'package:song_reads/clients/api_client.dart';
import 'package:song_reads/utils/secrets_utils.dart';

class GeniusApiClient extends ApiClient{
  final http.Client httpClient;
  Future<String> apiKey;
  static const CommentSource sourceType = CommentSource.genius;

  GeniusApiClient({@required this.httpClient,}) : assert(httpClient != null) {
    apiKey = loadSecret(secretPath: 'assets/secrets.json', key: 'genius_api_key');
  }

  @override
  Future<List<GeniusSong>> searchSong(String title, String artist, [int maxResults]) async {
    final String key = await apiKey;
    final String query = '$title $artist';
    //TODO: use authorization header for key
    final String uri = '${LiteralConstants.baseGeniusApiUrl}/search?q=$query&access_token=$key';
    final uriEncoded = Uri.encodeFull(uri);
    final response = parseResponse(await httpClient.get(uriEncoded));
    //TODO: currently assumes top result is the desired one, needs more validation, like title validation
    //TODO: check if hits is empty in api client before passing this over
    final Map<String,dynamic> topSongResult = sourceType.resultsFromResponse(response)[0]['result'];
    return [GeniusSong.fromJson(topSongResult)];
  }

  @override
  Future<void> getSongComments() {
    // TODO: implement getSongComments
    throw UnimplementedError();
  }
}

