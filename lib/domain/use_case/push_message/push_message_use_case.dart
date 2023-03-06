import 'package:frontend/domain/repository/push_message/push_message_repository.dart';

class PushMessageUseCase {
  final PushMessageRepository pushMessagePermissionRepository;

  PushMessageUseCase({
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

  Future<String?> getIsMarketingConsentAgree() async {
    return await pushMessagePermissionRepository.getIsMarketingConsentAgree();
  }

  Future<void> setMarketingConsentAgree(String isMarketingConsentAgree) async {
    await pushMessagePermissionRepository
        .setMarketingConsentAgree(isMarketingConsentAgree);
  }

  Future<void> deleteMarketingConsentAgree() async {
    await pushMessagePermissionRepository.deleteMarketingConsentAgree();
  }

  Future<String?> getPushMessageTime() async {
    return await pushMessagePermissionRepository.getPushMessageTime();
  }

  Future<void> setPushMessageTime(String isPushMessageTime) async {
    await pushMessagePermissionRepository.setPushMessageTime(isPushMessageTime);
  }

  Future<void> deletePushMessageTime() async {
    await pushMessagePermissionRepository.deletePushMessageTime();
  }
}
