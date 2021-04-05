//https://medium.com/flutter-community/using-hive-instead-of-sharedpreferences-for-storing-preferences-2d98c9db930f
import 'package:hive/hive.dart';

class TokenStore {
  static const tokenBoxKey = 'token_box_key';
  final Box<dynamic> _box;

  TokenStore._(this._box);

  static TokenStore get instance {
    final Box<dynamic> box = Hive.box(tokenBoxKey);
    return TokenStore._(box);
  }

  //Could be String or int depending on key passed in
  dynamic getValue(String key) => _getValue(key) ?? null;
  Future<void> setValue(String key, dynamic value) => _setValue(key, value);
  Future<void> deleteValue(String key) => _deleteValue(key);
  bool hasKey(String key) => _hasKey(key);


  T _getValue<T>(dynamic key, {T defaultValue}) => _box.get(key, defaultValue: defaultValue) as T;
  Future<void> _setValue<T>(dynamic key, T value) => _box.put(key, value);
  Future<void> _deleteValue<T>(dynamic key) => _box.delete(key);
  bool _hasKey<T>(dynamic key) => _box.containsKey(key);
}