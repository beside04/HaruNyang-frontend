import 'package:frontend/data/data_source/local_data/secure_storage/push_message_permission_data_source.dart';
import 'package:frontend/domain/repository/push_message_permission/push_message_permission_repository.dart';

class PushMessagePermissionRepositoryImpl implements PushMessagePermissionRepository {
  final PushMessagePermissionDataSource _dataSource = PushMessagePermissionDataSource();

  @override
  Future<String?> getIsPushMessagePermission() async {
    return await _dataSource.getIsPushMessagePermission();
  }

  @override
  Future<void> setPushMessagePermission(String isDarkMode) async {
    await _dataSource.setPushMessagePermission(isDarkMode);
  }

  @override
  Future<void> deletePushMessagePermissionData() async {
    await _dataSource.deletePushMessagePermission();
  }
}
