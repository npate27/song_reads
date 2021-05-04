import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:song_reads/constants/enums.dart';
import 'package:song_reads/constants/literals.dart' as LiteralConstants;
import 'package:song_reads/models/models.dart';
import 'package:song_reads/clients/api_client.dart';
import 'package:song_reads/utils/api_utils.dart';
import 'package:song_reads/utils/secrets_utils.dart';

class GeniusApiClient extends ApiClient{
  final http.Client httpClient;
  static const CommentSource sourceType = CommentSource.genius;

  GeniusApiClient({@required this.httpClient,}) : assert(httpClient != null);

  @override
  Future<List<GeniusSong>> searchSong(String title, String artist, [int maxResults]) async {
    //TODO is this + substitution needed? %20 normal encoding should just work I think
    final String query = '$title $artist'.replaceAll(RegExp(' +'), '+');
    final String uri = '${LiteralConstants.baseGeniusApiUrl}/search/multi?q=$query';
    final uriEncoded = Uri.parse(Uri.encodeFull(uri));
    final response = parseResponse(await httpClient.get(uriEncoded));
    //TODO: currently assumes top result is the desired one, needs more validation, like title validation
    //TODO: check if hits is empty in api client before passing this over
    final Map<String,dynamic> topSongResult = sourceType.resultsFromResponse(response, false)[0]['result'];
    final int commentCount = await getCommentsCount(topSongResult['id']);
    topSongResult['comments_count'] = commentCount;
    return [GeniusSong.fromJson(topSongResult)];
  }

  @override
  Future<List<CommentInfo>> getSongComments(String id) async {
    final String uri = '${LiteralConstants.baseGeniusApiUrl}/songs/$id/comments?page=1&text_format=html';
    final uriEncoded = Uri.parse(Uri.encodeFull(uri));
    final response = parseResponse(await httpClient.get(uriEncoded));
    final List<dynamic> commentResult = sourceType.resultsFromResponse(response, true);
    Map<String, dynamic> map = Map();
    map['commentResult'] = commentResult;
    map['sourceType'] = sourceType;
    return compute(parseJsonToCommentList, map);
  }

  Future<int> getCommentsCount(int id) async {
    final String uri = '${LiteralConstants.baseGeniusApiUrl}/songs/$id/comments?page=1&text_format=html';
    final uriEncoded = Uri.parse(Uri.encodeFull(uri));
    final response = parseResponse(await httpClient.get(uriEncoded));
    return response['response']['total_count'];

  }
}

