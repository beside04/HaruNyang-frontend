import 'package:frontend/domain/repository/push_message_permission/push_message_permission_repository.dart';

class PushMessagePermissionUseCase {
  final PushMessagePermissionRepository pushMessagePermissionRepository;

  PushMessagePermissionUseCase({
    required this.pushMessagePermissionRepository,
  });

  Future<String?> getIsPushMessagePermission() async {
    return await pushMessagePermissionRepository.getIsPushMessagePermission();
  }

  Future<void> setPushMessagePermission(String isPushMessagePermission) async {
    await pushMessagePermissionRepository
        .setPushMessagePermission(isPushMessagePermission);
  }

  Future<void> deletePushMessagePermissionData() async {
    await pushMessagePermissionRepository.deletePushMessagePermissionData();
  }
}
