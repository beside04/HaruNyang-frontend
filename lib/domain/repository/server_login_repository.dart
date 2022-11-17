abstract class ServerLoginRepository {
  Future<void> login(String loginType, String socialId);

  Future<void> logout();
}
