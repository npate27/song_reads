import 'package:flutter/foundation.dart';
import 'package:song_reads/clients/api_client.dart';

abstract class Repository {
  final ApiClient apiClient;

  Repository({@required this.apiClient});

  Future<void> searchSong(String title, String artist);
  Future<void> getSongComments();
}