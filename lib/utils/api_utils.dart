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
    // TODO: Handle this case.
    break;
    case CommentSource.youtube:
      return commentResult.map((result) => CommentInfo.fromJson(result, sourceType)).toList();
      break;
    case CommentSource.reddit:
      return commentResult.map((result) => CommentInfo.fromJson(result['data'], sourceType)).toList();
      break;
  }
}