import 'package:frontend/data/data_source/local_data/secure_storage/local_secure_data_source.dart';

class PushMessagePermissionDataSource {
  final LocalSecureDataSource localSecureDataSource = LocalSecureDataSource();

  Future<String?> getIsPushMessagePermission() async {
    return await localSecureDataSource.loadData(
      key: 'PUSH_MESSAGE_PERMISSION',
    );
  }

  Future<void> setPushMessagePermission(data) async {
    return await localSecureDataSource.saveData(
      key: 'PUSH_MESSAGE_PERMISSION',
      data: data,
    );
  }

  Future<void> deletePushMessagePermission() async {
    return await localSecureDataSource.deleteAllData();
  }
}
