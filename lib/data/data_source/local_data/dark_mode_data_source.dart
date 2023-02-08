import 'package:frontend/data/data_source/local_data/local_secure_data_source.dart';

class DarkModeDataSource {
  final LocalSecureDataSource localSecureDataSource = LocalSecureDataSource();

  Future<String?> getIsDarkMode() async {
    return await localSecureDataSource.loadData(
      key: 'DARK_MODE',
    );
  }

  Future<void> setDarkMode(data) async {
    return await localSecureDataSource.saveData(
      key: 'DARK_MODE',
      data: data,
    );
  }

  Future<void> deleteDarkModeData() async {
    return await localSecureDataSource.deleteAllData();
  }
}
