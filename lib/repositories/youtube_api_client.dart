import 'package:http/http.dart' as http;
import 'package:song_reads/constants/literals.dart' as LiteralConstants;
import 'package:song_reads/repositories/api_client.dart';
import 'package:song_reads/utils/secret_loader.dart';

class YouTubeApiClient implements ApiClient {
  @override
  final http.Client httpClient;

  @override
  Future<String> apiKey;

  YouTubeApiClient({this.httpClient,}) {
    apiKey = SecretLoader(secretPath: 'assets/secrets.json', key: 'youtube_api_key').load();
  }

  //TODO: Return meaningful information
  @override
  Future<void> searchSong(String title, String artist) async{
    final String key = await apiKey;
    final String query = '$title $artist';
    final String uri = '${LiteralConstants.baseYoutubeApiUrl}/search?part=snippet&q=$query&key=$key';
    final uriEncoded = Uri.encodeFull(uri);
    print(uriEncoded.toString());
    final http.Response response = await this.httpClient.get(uriEncoded);
    print(response.body);
    print("Youtube search");
  }

  @override
  Future<void> getSongComments() {
    // TODO: implement getSongComments
    throw UnimplementedError();
  }
}