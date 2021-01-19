import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:song_reads/constants/literals.dart' as LiteralConstants;
import 'package:song_reads/models/models.dart';
import 'package:song_reads/clients/api_client.dart';

class RedditApiClient extends ApiClient {
  final http.Client httpClient;
  Future<String> apiKey;

  RedditApiClient({this.httpClient,});

  @override
  Future<RedditThread> searchSong(String title, String artist) async{
    final String query = '$title $artist';
    final String uri = '${LiteralConstants.baseRedditApiUrl}/search.json?q=$query&sort=top';
    final uriEncoded = Uri.encodeFull(uri);
    final response = parseResponse(await httpClient.get(uriEncoded));
    //TODO: determine how many threads is enough, currently using top one for test
    //TODO: check if hits is empty in api client before passing this over
    //TODO: check response status
    final Map<String,dynamic> threadResult = response['data']['children'][0]['data'];
    return RedditThread.fromJson(threadResult);
  }

  @override
  Future<void> getSongComments() {
    // TODO: implement getSongComments
    throw UnimplementedError();
  }
}