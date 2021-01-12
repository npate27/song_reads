import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

abstract class ApiClient{
  Future<String> apiKey;
  final http.Client httpClient;

  ApiClient(this.httpClient);

  Future<void> searchSong(String title, String artist);
  Future<void> getSongComments();

}