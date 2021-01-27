import 'package:shared_preferences/shared_preferences.dart';
import 'package:song_reads/constants/enums.dart';
import 'package:song_reads/constants/defaults.dart';
import 'package:song_reads/constants/literals.dart';

void setSourcePreference(CommentSource source, bool useSource) {
  SharedPreferences.getInstance().then((prefs) => prefs.setBool(source.toString(), useSource));
}

void setMaxResultPreference(int maxResults) {
  SharedPreferences.getInstance().then((prefs) => prefs.setInt(maxResultsPreferenceKey, maxResults));
}

Future<bool> getSourcePreference(CommentSource source) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool(source.inString) ?? useSourceDefault;
}

Future<int> getMaxResultPreference() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt(maxResultsPreferenceKey) ?? maxResultsDefault;
}