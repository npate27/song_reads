//https://medium.com/flutter-community/using-hive-instead-of-sharedpreferences-for-storing-preferences-2d98c9db930f
import 'package:hive/hive.dart';
import 'package:song_reads/constants/defaults.dart';
import 'package:song_reads/constants/enums.dart';
import 'package:song_reads/constants/literals.dart';


class PreferencesStore {
  static const preferencesBoxKey = 'preferences_box_key';
  final Box<dynamic> _box;

  PreferencesStore._(this._box);

  static PreferencesStore get instance {
    final Box<dynamic> box = Hive.box(preferencesBoxKey);
    return PreferencesStore._(box);
  }

  int maxResultsPref() => _getValue(maxResultsPreferenceKey) ?? maxResultsDefault;
  Future<void> setMaxResultsPref(int maxResults) => _setValue(maxResultsPreferenceKey, maxResults);

  bool sourcePref(CommentSource source) => _getValue(source.inString) ?? useSourceDefault;
  Future<void> setSourcePref(CommentSource source, bool useSource) => _setValue(source.inString, useSource);

  T _getValue<T>(dynamic key, {T defaultValue}) => _box.get(key, defaultValue: defaultValue) as T;
  Future<void> _setValue<T>(dynamic key, T value) => _box.put(key, value);
}