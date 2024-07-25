import 'package:frontend/data/data_source/local_data/secure_storage/local_secure_data_source.dart';

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

  Future<String?> getDeviceId() async {
    return await localSecureDataSource.loadData(
      key: 'DEVICE_ID',
    );
  }

  Future<void> setDeviceId(data) async {
    return await localSecureDataSource.saveData(
      key: 'DEVICE_ID',
      data: data,
    );
  }

  Future<String?> getLoginType() async {
    return await localSecureDataSource.loadData(
      key: 'LOGIN_TYPE',
    );
  }

  Future<void> setLoginType(data) async {
    return await localSecureDataSource.saveData(
      key: 'LOGIN_TYPE',
      data: data,
    );
  }

  Future<String?> getSocialId() async {
    return await localSecureDataSource.loadData(
      key: 'SOCIAL_ID',
    );
  }

  Future<void> setSocialId(data) async {
    return await localSecureDataSource.saveData(
      key: 'SOCIAL_ID',
      data: data,
    );
  }

  Future<void> deleteAllToken() async {
    return await localSecureDataSource.deleteAllData();
  }
}
