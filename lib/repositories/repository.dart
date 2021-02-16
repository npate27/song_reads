import 'package:flutter/foundation.dart';
import 'package:song_reads/clients/api_client.dart';
import 'package:song_reads/models/comment_info.dart';
import 'package:song_reads/models/models.dart';

abstract class Repository {
  final ApiClient apiClient;

  Repository({@required this.apiClient});

  Future<List<Source>> searchSong(String title, String artist);
  Future<List<CommentInfo>> getSongComments(String id);
}