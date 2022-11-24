abstract class TokenRepository {
  Future<String?> getAccessToken();

  Future<void> setAccessToken(String token);

  Future<String?> getRefreshToken();

  Future<void> setRefreshToken(String token);

  Future<void> deleteAllToken();
}
