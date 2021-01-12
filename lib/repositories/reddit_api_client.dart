import 'package:http/http.dart' as http;
import 'package:song_reads/constants/literals.dart' as LiteralConstants;
import 'package:song_reads/repositories/api_client.dart';

class RedditApiClient implements ApiClient {
  @override
  final http.Client httpClient;

  @override
  Future<String> apiKey;

  RedditApiClient({this.httpClient,});

  //TODO: Return meaningful information
  @override
  Future<void> searchSong(String title, String artist) async{
    final String query = '$title $artist';
    final String uri = '${LiteralConstants.baseRedditApiUrl}/search.json?q=$query&sort=top';
    final uriEncoded = Uri.encodeFull(uri);
    final http.Response response = await this.httpClient.get(uriEncoded);
    print(response.body);
    print("Reddit search");
  }

  @override
  Future<void> getSongComments() {
    // TODO: implement getSongComments
    throw UnimplementedError();
  }


}