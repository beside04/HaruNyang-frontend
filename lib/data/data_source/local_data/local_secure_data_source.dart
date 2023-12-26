import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalSecureDataSource {
  LocalSecureDataSource._privateConstructor();

  static final LocalSecureDataSource _instance = LocalSecureDataSource._privateConstructor();

  factory LocalSecureDataSource() {
    return _instance;
  }

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<String?> loadData({required String key}) async {
    try {
      return await secureStorage.read(key: key);
    } on PlatformException catch (e) {
      // Workaround for https://github.com/mogol/flutter_secure_storage/issues/43
      await secureStorage.deleteAll();
    }
    return null;
  }

  Future<void> saveData({required String key, required String data}) async {
    await secureStorage.write(key: key, value: data);
  }

  Future<void> deleteData({required String key}) async {
    await secureStorage.delete(key: key);
  }

  Future<void> deleteAllData() async {
    await secureStorage.deleteAll();
  }
}
