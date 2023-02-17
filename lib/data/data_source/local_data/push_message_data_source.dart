import 'package:frontend/data/data_source/local_data/local_secure_data_source.dart';

class PushMessageDataSource {
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
    return await localSecureDataSource.deleteData(
      key: 'PUSH_MESSAGE_PERMISSION',
    );
  }

  Future<String?> getIsMarketingConsentAgree() async {
    return await localSecureDataSource.loadData(
      key: 'MARKETING_CONSENT_AGREE',
    );
  }

  Future<void> setMarketingConsentAgree(data) async {
    return await localSecureDataSource.saveData(
      key: 'MARKETING_CONSENT_AGREE',
      data: data,
    );
  }

  Future<void> deleteMarketingConsentAgree() async {
    return await localSecureDataSource.deleteData(
      key: 'MARKETING_CONSENT_AGREE',
    );
  }

  Future<String?> getPushMessageTime() async {
    return await localSecureDataSource.loadData(
      key: 'PUSH_MESSAGE_TIME',
    );
  }

  Future<void> setPushMessageTime(data) async {
    return await localSecureDataSource.saveData(
      key: 'PUSH_MESSAGE_TIME',
      data: data,
    );
  }

  Future<void> deletePushMessageTime() async {
    return await localSecureDataSource.deleteData(
      key: 'PUSH_MESSAGE_TIME',
    );
  }
}
