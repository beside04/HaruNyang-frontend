abstract class PasswordRepository {
  //비밀번호 설정 토글 on/off
  Future<bool?> getIsPasswordSetting();

  Future<void> setIsPassword(bool data);

  //비밀번호 정보
  Future<String?> getPassword();

  Future<void> setPassword(String data);

  //생체인증 잠금 토글 on/off
  Future<bool?> getIsBioAuth();

  Future<void> setIsBioAuth(bool data);

  //힌트 정보
  Future<String?> getHint();

  Future<void> setHint(String data);

  Future<void> deleteHint();
}
