//https://medium.com/flutter-community/using-hive-instead-of-sharedpreferences-for-storing-preferences-2d98c9db930f
import 'package:hive/hive.dart';

class TokenStore {
  static const _token_store = '_token_store';
  final Box<dynamic> _box;

  TokenStore._(this._box);

  static Future<TokenStore> get instance async {
    final box = await Hive.openBox<dynamic>(_token_store);
    return TokenStore._(box);
  }

  //Could be String or int depending on key passed in
  dynamic getValue(String key) => _getValue(key) ?? null;
  Future<void> setValue(String key, dynamic value) => _setValue(key, value);

  T _getValue<T>(dynamic key, {T defaultValue}) => _box.get(key, defaultValue: defaultValue) as T;
  Future<void> _setValue<T>(dynamic key, T value) => _box.put(key, value);
}