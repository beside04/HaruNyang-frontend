abstract class ServerLoginRepository {
  Future<void> login(String loginType, String socialId);

  Future<void> logout();

  Future<bool> checkMember(String socialId);

  Future<bool> signup(String email, String loginType, String socialId);
}
