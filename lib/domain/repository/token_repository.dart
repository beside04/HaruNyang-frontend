abstract class TokenRepository {
  Future<String?> getAccessToken();

  Future<void> setAccessToken(String token);

  Future<String?> getRefreshToken();

  Future<void> setRefreshToken(String token);

  Future<String?> getDeviceId();

  Future<void> setDeviceId(String id);

  Future<String?> getLoginType();

  Future<void> setLoginType(String id);

  Future<String?> getSocialId();

  Future<void> setSocialId(String id);

  Future<void> deleteAllToken();
}
