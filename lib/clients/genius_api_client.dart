import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:song_reads/constants/literals.dart' as LiteralConstants;
import 'package:song_reads/models/models.dart';
import 'package:song_reads/clients/api_client.dart';
import 'package:song_reads/utils/secret_loader.dart';

class GeniusApiClient implements ApiClient{
  final http.Client httpClient;
  Future<String> apiKey;

  GeniusApiClient({this.httpClient,}) {
    apiKey = SecretLoader(secretPath: 'assets/secrets.json', key: 'genius_api_key').load();
  }

  //TODO: Return meaningful information
  @override
  Future<GeniusSong> searchSong(String title, String artist) async {
    final String key = await apiKey;
    final String query = '$title $artist';
    //TODO: use authorization header for key
    //TODO: filter my music relevant subreddits only
    final String uri = '${LiteralConstants.baseGeniusApiUrl}/search?q=$query&access_token=$key';
    final uriEncoded = Uri.encodeFull(uri);
    final http.Response response = await this.httpClient.get(uriEncoded);
    //TODO: currently assumes top result is the desired one, needs more validation, like title validation
    //TODO: check if hits is empty in api client before passing this over
    //TODO: check response status
    final Map<String,dynamic> topSongResult = jsonDecode(response.body)['response']['hits'][0]['result'];
    return GeniusSong.fromJson(topSongResult);
  }

  @override
  Future<void> getSongComments() {
    // TODO: implement getSongComments
    throw UnimplementedError();
  }
}

