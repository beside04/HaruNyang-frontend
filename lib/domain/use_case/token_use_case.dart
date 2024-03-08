import 'package:frontend/domain/repository/token_repository.dart';

class TokenUseCase {
  final TokenRepository tokenRepository;

  TokenUseCase({
    required this.tokenRepository,
  });

  Future<String?> getAccessToken() async {
    return await tokenRepository.getAccessToken();
  }

  Future<void> setAccessToken(String token) async {
    await tokenRepository.setAccessToken(token);
  }

  Future<String?> getLoginType() async {
    return await tokenRepository.getLoginType();
  }

  Future<void> setLoginType(String type) async {
    await tokenRepository.setLoginType(type);
  }

  Future<String?> getSocialId() async {
    return await tokenRepository.getSocialId();
  }

  Future<void> setSocialId(String id) async {
    await tokenRepository.setSocialId(id);
  }

  Future<void> deleteAllToken() async {
    await tokenRepository.deleteAllToken();
  }
}
