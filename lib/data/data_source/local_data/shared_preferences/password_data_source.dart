import 'package:frontend/data/data_source/local_data/shared_preferences/shared_preferences_data_source.dart';

class PasswordDataSource {
  final SharedPreferencesDataSource sharedPreferencesDataSource = SharedPreferencesDataSource();

  Future<bool?> getIsPassword() async {
    return await sharedPreferencesDataSource.loadData(
      key: 'IS_PASSWORD',
    );
  }

  Future<void> setIsPassword(bool data) async {
    return await sharedPreferencesDataSource.saveData(
      key: 'IS_PASSWORD',
      data: data,
    );
  }

  Future<String?> getPassword() async {
    return await sharedPreferencesDataSource.loadData(
      key: 'PASSWORD',
    );
  }

  Future<void> setPassword(String data) async {
    return await sharedPreferencesDataSource.saveData(
      key: 'PASSWORD',
      data: data,
    );
  }

  Future<bool?> getIsBioAuth() async {
    return await sharedPreferencesDataSource.loadData(
      key: 'IS_BIO_AUTH',
    );
  }

  Future<void> setIsBioAuth(bool data) async {
    return await sharedPreferencesDataSource.saveData(
      key: 'IS_BIO_AUTH',
      data: data,
    );
  }

  Future<String?> getHint() async {
    return await sharedPreferencesDataSource.loadData(
      key: 'HINT',
    );
  }

  Future<void> setHint(String data) async {
    return await sharedPreferencesDataSource.saveData(
      key: 'HINT',
      data: data,
    );
  }

  Future<void> deleteHint() async {
    return await sharedPreferencesDataSource.deleteData(
      key: 'HINT',
    );
  }

  Future<void> deletePushMessagePermission() async {
    return await sharedPreferencesDataSource.deleteAllData();
  }
}
