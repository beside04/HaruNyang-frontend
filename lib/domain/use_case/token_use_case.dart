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

  Future<String?> getRefreshToken() async {
    return await tokenRepository.getRefreshToken();
  }

  Future<void> setRefreshToken(String token) async {
    await tokenRepository.setRefreshToken(token);
  }

  Future<void> deleteAllToken() async {
    await tokenRepository.deleteAllToken();
  }
}
