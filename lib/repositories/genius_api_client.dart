import 'package:http/http.dart' as http;
import 'package:song_reads/constants/literals.dart' as LiteralConstants;
import 'package:song_reads/repositories/api_client.dart';
import 'package:song_reads/utils/secret_loader.dart';

class GeniusApiClient implements ApiClient{
  @override
  final http.Client httpClient;

  @override
  Future<String> apiKey;

  GeniusApiClient({this.httpClient,}) {
    apiKey = SecretLoader(secretPath: 'assets/secrets.json', key: 'genius_api_key').load();
  }

  //TODO: Return meaningful information
  @override
  Future<void> searchSong(String title, String artist) async {
    final String key = await apiKey;
    final String query = '$title $artist';
    final String uri = '${LiteralConstants.baseGeniusApiUrl}/search?q=$query&access_token=$key';
    final uriEncoded = Uri.encodeFull(uri);
    final http.Response response = await this.httpClient.get(uriEncoded);
    print(response.body);
    print("Genius search");
  }

  @override
  Future<void> getSongComments() {
    // TODO: implement getSongComments
    throw UnimplementedError();
  }
}

