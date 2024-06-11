import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesDataSource {
  SharedPreferencesDataSource._privateConstructor();

  static final SharedPreferencesDataSource _instance = SharedPreferencesDataSource._privateConstructor();

  factory SharedPreferencesDataSource() {
    return _instance;
  }

  SharedPreferences? _sharedPreferences;

  SharedPreferences? get sharedPreferences => _sharedPreferences;

  Future<T?> loadData<T>({required String key}) async {
    _instance._sharedPreferences ??= await SharedPreferences.getInstance();

    if (_sharedPreferences == null) return null;
    switch (T) {
      case String:
        return _sharedPreferences?.getString(key) as T?;
      case int:
        return _sharedPreferences?.getInt(key) as T?;
      case double:
        return _sharedPreferences?.getDouble(key) as T?;
      case bool:
        return _sharedPreferences?.getBool(key) as T?;
      case const (List<String>):
        return _sharedPreferences?.getStringList(key) as T?;
      default:
        throw UnsupportedError('Type not supported');
    }
  }

  Future<void> saveData<T>({required String key, required T data}) async {
    _instance._sharedPreferences ??= await SharedPreferences.getInstance();

    if (_sharedPreferences == null) return;
    switch (T) {
      case String:
        await _sharedPreferences?.setString(key, data as String);
        break;
      case int:
        await _sharedPreferences?.setInt(key, data as int);
        break;
      case double:
        await _sharedPreferences?.setDouble(key, data as double);
        break;
      case bool:
        await _sharedPreferences?.setBool(key, data as bool);
        break;
      case const (List<String>):
        await _sharedPreferences?.setStringList(key, data as List<String>);
        break;
      default:
        throw UnsupportedError('Type not supported');
    }
  }

  Future<void> deleteData({required String key}) async {
    _instance._sharedPreferences ??= await SharedPreferences.getInstance();

    await _sharedPreferences?.remove(key);
  }

  Future<void> deleteAllData() async {
    _instance._sharedPreferences ??= await SharedPreferences.getInstance();

    await _sharedPreferences?.clear();
  }
}
