import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:song_reads/constants/enums.dart';
import 'package:song_reads/constants/literals.dart' as LiteralConstants;
import 'package:song_reads/models/models.dart';
import 'package:song_reads/clients/api_client.dart';
import 'package:song_reads/utils/api_utils.dart';

class RedditApiClient extends ApiClient {
  final http.Client httpClient;
  Future<String> apiKey; //TODO: is this needed for this client?
  static const CommentSource sourceType = CommentSource.reddit;

  RedditApiClient({@required this.httpClient,}) : assert(httpClient != null);

  @override
  Future<List<RedditThread>> searchSong(String title, String artist, [int maxResults]) async {
    //TODO: stuff like "Pi'erre" only gets some of the results for reddit, use OR to get more results for those
    final String query = 'title:(${'$title $artist'.replaceAll(RegExp(' +'), ' AND ')})';
    //TODO: filter my music relevant subreddits only
    final String uri = '${LiteralConstants.baseRedditApiUrl}/search.json?q=$query&sort=top';
    final uriEncoded = Uri.parse(Uri.encodeFull(uri));
    final response = parseResponse(await httpClient.get(uriEncoded));
    //TODO: check if hits is empty in api client before passing this over

    final List<dynamic> threadResult = sourceType.resultsFromResponse(response, false, maxResults);
    final List<RedditThread> result = threadResult.map((result) => RedditThread.fromJson(result['data'])).toList();
    return result;
  }

  @override
  Future<List<CommentInfo>> getSongComments(String id) async {
    final String uri = '${LiteralConstants.baseRedditApiUrl}/comments/$id.json';
    final uriEncoded = Uri.parse(Uri.encodeFull(uri));
    final response = parseResponse(await httpClient.get(uriEncoded));
    //getting second elem since first elem contains thread info. TODO: do this by looking at [data][children][kind] == "t1"
    final List<dynamic> commentResult = sourceType.resultsFromResponse(response[1], true);
    Map<String, dynamic> map = Map();
    map['commentResult'] = commentResult;
    map['sourceType'] = sourceType;
    return compute(parseJsonToCommentList, map);
  }
}