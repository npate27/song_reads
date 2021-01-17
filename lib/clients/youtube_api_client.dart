import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:song_reads/constants/literals.dart' as LiteralConstants;
import 'package:song_reads/models/models.dart';
import 'package:song_reads/clients/api_client.dart';
import 'package:song_reads/utils/secret_loader.dart';

class YouTubeApiClient implements ApiClient {
  final http.Client httpClient;
  Future<String> apiKey;

  YouTubeApiClient({this.httpClient,}) {
    apiKey = SecretLoader(secretPath: 'assets/secrets.json', key: 'youtube_api_key').load();
  }

  //TODO: Return meaningful information
  @override
  Future<YoutubeVideo> searchSong(String title, String artist) async{
    final String key = await apiKey;
    final String query = '$title $artist';
    //TODO: use authorization header for key
    //part=snippet gives more info to parse and verify, id just gives
    final String uri = '${LiteralConstants.baseYoutubeApiUrl}/search?part=snippet&q=$query&key=$key';
    final uriEncoded = Uri.encodeFull(uri);
    final http.Response response = await this.httpClient.get(uriEncoded);
    //TODO: determine how many vids is enough, currently using top one for test
    //TODO: check if hits is empty in api client before passing this over
    //TODO requery  here for likes and num comments
    //TODO: check response status
    final Map<String,dynamic> videoResult = jsonDecode(response.body)['items'][0];
    final String videoId = videoResult['id']['videoId'];
    final Map<String,dynamic> videoStats = await getVideoStats(videoId, key);
    videoResult.addAll(videoStats);
    return YoutubeVideo.fromJson(videoResult);
  }

  Future<Map<String,dynamic>> getVideoStats(String videoId, String key) async{
    final String uri = '${LiteralConstants.baseYoutubeApiUrl}/videos?part=statistics&id=$videoId&key=$key';
    final uriEncoded = Uri.encodeFull(uri);
    final http.Response response = await this.httpClient.get(uriEncoded);
    //TODO: check response status
    return jsonDecode(response.body)['items'][0];
  }

  @override
  Future<void> getSongComments() {
    // TODO: implement getSongComments
    throw UnimplementedError();
  }
}