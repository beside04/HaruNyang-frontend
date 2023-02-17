abstract class PushMessageRepository {
  Future<String?> getIsPushMessagePermission();

  Future<void> setPushMessagePermission(String isPushMessagePermission);

  Future<void> deletePushMessagePermissionData();

  Future<String?> getIsMarketingConsentAgree();

  Future<void> setMarketingConsentAgree(String isMarketingConsentAgree);

  Future<void> deleteMarketingConsentAgree();

  Future<String?> getPushMessageTime();

  Future<void> setPushMessageTime(String pushMessageTime);

  Future<void> deletePushMessageTime();
}
