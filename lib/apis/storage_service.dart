
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _userIdKey = 'userId';
const String _accessTokenKey = 'accessToken';
const String _refreshTokenKey = 'refreshToken';
const String _tokenExpiredAtKey = 'tokenExpiredAt';
const String _refreshTokenExpiredAtKey = 'refreshTokenExpiredAtKey';

class StorageService {
  StorageService._privateConstructor();
  static final StorageService _instance = StorageService._privateConstructor();

  factory StorageService() {
    return _instance;
  }
  final _secureStorage = const FlutterSecureStorage();

  Future<void> getAllSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    for (String key in prefs.getKeys()) {
      var value = prefs.get(key);
      print('printAllSharedPreferences ::::: Key: $key, Value: $value');
    }
  }

  Future<void> getAllValuesWithKeyPattern(String pattern) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, String?> result = {};

    for (String key in prefs.getKeys()) {
      if (key.contains(pattern)) {
        result[key] = prefs.getString(key);
        print('get All Keys And Values::: Key: $key, Value: ${result[key]}');
      }
    }
  }

  Future<void> removeAllValuesWithKeyPattern(String pattern) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    for (String key in prefs.getKeys()) {
      if (key.contains(pattern)) {
        await prefs.remove(key);
        print('Removed Key: $key');
      }
    }
  }

  Future<String?> getAccessToken() async {
    return await _readSecureData(_accessTokenKey);
  }

  Future<void> setAccessToken(String value) async {
    await _writeSecureData(_accessTokenKey, value);
  }

  Future<String?> getRefreshToken() async {
    return await _readSecureData(_refreshTokenKey);
  }

  Future<void> setRefreshToken(String value) async {
    await _writeSecureData(_refreshTokenKey, value);
  }

  Future<String?> getUserId() async {
    return await _readSecureData(_userIdKey);
  }

  Future<void> setUserId(String value) async {
    await _writeSecureData(_userIdKey, value);
  }

  Future<String?> getTokenExpiredAtKey() async {
    return await _getString(_tokenExpiredAtKey);
  }

  Future<void> setTokenExpiredAtKey(String value) async {
    await _setString(_tokenExpiredAtKey, value);
  }

  Future<String?> getRefreshTokenExpiredAt() async {
    return await _getString(_refreshTokenExpiredAtKey);
  }

  Future<void> setRefreshTokenExpiredAt(String value) async {
    await _setString(_refreshTokenExpiredAtKey, value);
  }


  Future<void> clear() async {

    await _deleteAllSecureData();

  }

  Future<void> clearAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await _deleteAllSecureData();

    await prefs.clear();
  }

  //.setting
  // preferences
  Future<int?> _getInt(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  Future<String?> getString(String key) async {
    return _getString(key);
  }

  Future<String?> _getString(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<bool?> _getBool(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  Future<void> _setInt(String key, int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  Future<void> setString(String key, String value) async {
    _setString(key, value);
  }

  Future<void> _setString(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future<void> _setBool(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  Future<void> _deleteAllSecureData() async {
    await _secureStorage.deleteAll(aOptions: _getAndroidOptions());
  }

  Future<void> _deleteSecureData(String key) async {
    await _secureStorage.delete(key: key, aOptions: _getAndroidOptions());
  }

  Future<String?> _readSecureData(String key) async {
    var readData =
    await _secureStorage.read(key: key, aOptions: _getAndroidOptions());
    return readData;
  }

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: false,
  );

  Future<void> _writeSecureData(String key, String value) async {
    await _secureStorage
        .write(
      key: key,
      value: value,
      aOptions: _getAndroidOptions(),
    )
        .then((value) => print('successful writing.'));
  }
//.secure
}
