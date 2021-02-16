import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:song_reads/models/models.dart';

abstract class ApiClient {
  Future<String> apiKey;
  final http.Client httpClient;

  ApiClient({this.httpClient});

  Future<List<Source>> searchSong(String title, String artist);

  Future<List<CommentInfo>> getSongComments(String id);

  Map<String,dynamic> parseResponse(http.Response response) {
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load response');
    }
  }
  Map<String,dynamic> getResults(Map<String, dynamic> json) {
    //Get preferences
    //get data from preference
  }
}