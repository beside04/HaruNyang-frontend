abstract class AccessTokenRepository {
  Future<String> getAccessToken();

  Future<void> setAccessToken(String token);
}
