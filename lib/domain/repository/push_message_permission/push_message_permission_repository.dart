abstract class PushMessagePermissionRepository {
  Future<String?> getIsPushMessagePermission();

  Future<void> setPushMessagePermission(String isDarkMode);

  Future<void> deletePushMessagePermissionData();
}
