import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalSecureDataSource {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  LocalSecureDataSource();

  Future<String?> loadData(String key) async {
    return await secureStorage.read(key: key);
  }

  Future<void> saveData(String key, String data) async {
    await secureStorage.write(key: key, value: data);
  }

  Future<void> deleteData(String key) async {
    await secureStorage.delete(key: key);
  }
}
