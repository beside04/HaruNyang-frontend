import 'package:frontend/domain/repository/password/password_repository.dart';

class PasswordUseCase {
  final PasswordRepository passwordRepository;

  PasswordUseCase({
    required this.passwordRepository,
  });

  Future<bool?> getIsPasswordSetting() async {
    return await passwordRepository.getIsPasswordSetting();
  }

  Future<void> setIsPassword(bool data) async {
    return await passwordRepository.setIsPassword(data);
  }

  Future<String?> getPassword() async {
    return await passwordRepository.getPassword();
  }

  Future<void> setPassword(String data) async {
    return await passwordRepository.setPassword(data);
  }

  Future<bool?> getIsBioAuth() async {
    return await passwordRepository.getIsBioAuth();
  }

  Future<void> setIsBioAuth(bool data) async {
    return await passwordRepository.setIsBioAuth(data);
  }

  Future<String?> getHint() async {
    return await passwordRepository.getHint();
  }

  Future<void> setHint(String data) async {
    return await passwordRepository.setHint(data);
  }

  Future<void> deleteHint() async {
    return await passwordRepository.deleteHint();
  }
}
