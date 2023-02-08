import 'package:frontend/data/data_source/local_data/local_secure_data_source.dart';

class MemoryTokenDataSource {
  final LocalSecureDataSource localSecureDataSource = LocalSecureDataSource();

  Future<String?> getAccessToken() async {
    return await localSecureDataSource.loadData(
      key: 'ACCESS_TOKEN',
    );
  }

  Future<void> setAccessToken(data) async {
    return await localSecureDataSource.saveData(
      key: 'ACCESS_TOKEN',
      data: data,
    );
  }

  Future<String?> getRefreshToken() async {
    return await localSecureDataSource.loadData(
      key: 'REFRESH_TOKEN',
    );
  }

  Future<void> setRefreshToken(data) async {
    return await localSecureDataSource.saveData(
      key: 'REFRESH_TOKEN',
      data: data,
    );
  }

  Future<void> deleteAllToken() async {
    return await localSecureDataSource.deleteAllData();
  }
}
