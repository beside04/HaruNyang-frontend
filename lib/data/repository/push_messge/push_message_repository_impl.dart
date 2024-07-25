import 'package:frontend/data/data_source/local_data/secure_storage/push_message_data_source.dart';
import 'package:frontend/domain/repository/push_message/push_message_repository.dart';

class PushMessageRepositoryImpl implements PushMessageRepository {
  final PushMessageDataSource _dataSource = PushMessageDataSource();

  @override
  Future<String?> getIsPushMessagePermission() async {
    return await _dataSource.getIsPushMessagePermission();
  }

  @override
  Future<void> setPushMessagePermission(String isPushMessagePermission) async {
    await _dataSource.setPushMessagePermission(isPushMessagePermission);
  }

  @override
  Future<void> deletePushMessagePermissionData() async {
    await _dataSource.deletePushMessagePermission();
  }

  @override
  Future<String?> getIsMarketingConsentAgree() async {
    return await _dataSource.getIsMarketingConsentAgree();
  }

  @override
  Future<void> setMarketingConsentAgree(String isMarketingConsentAgree) async {
    await _dataSource.setMarketingConsentAgree(isMarketingConsentAgree);
  }

  @override
  Future<void> deleteMarketingConsentAgree() async {
    await _dataSource.deletePushMessagePermission();
  }

  @override
  Future<String?> getPushMessageTime() async {
    return await _dataSource.getPushMessageTime();
  }

  @override
  Future<void> setPushMessageTime(String pushMessageTime) async {
    return await _dataSource.setPushMessageTime(pushMessageTime);
  }

  @override
  Future<void> deletePushMessageTime() async {
    return await _dataSource.deletePushMessageTime();
  }
}
