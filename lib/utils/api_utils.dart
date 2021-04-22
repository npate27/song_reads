import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:song_reads/models/models.dart';
import 'package:song_reads/constants/enums.dart';

dynamic parseResponse(http.Response response) {
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }
  // For when spotify is not open or ad is playing
  else if (response.statusCode == 204) {
    return null;
  }
  else {
    throw Exception('Failed to load response');
  }
}

List<CommentInfo> parseJsonToCommentList(Map<String,dynamic> map) {
  List<dynamic> commentResult = map['commentResult'];
  CommentSource sourceType = map['sourceType'];
  switch(sourceType) {
    case CommentSource.genius:
      return commentResult.map((result) => CommentInfo.fromJson(result, sourceType)).toList();
    case CommentSource.youtube:
      return commentResult.map((result) => CommentInfo.fromJson(result, sourceType)).toList();
    case CommentSource.reddit:
      //Last element is a "more" object, not an actual comment, ingore it.
      //TODO: make this just ignore the very last element instead?
      List<CommentInfo> redditComments = commentResult.map((result) => result['kind'] == 't1' ? CommentInfo.fromJson(result['data'], sourceType) : null).toList();
      redditComments.removeWhere((result) => result == null);
      return redditComments;
  }
}