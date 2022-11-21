import 'package:frontend/domain/repository/aceess_token_repository.dart';

class AccessTokenUseCase {
  final AccessTokenRepository accessTokenRepository;

  AccessTokenUseCase({
    required this.accessTokenRepository,
  });

  Future<String> getAccessToken() async {
    return await accessTokenRepository.getAccessToken();
  }

  Future<void> setAccessToken(String token) async {
    await accessTokenRepository.setAccessToken(token);
  }
}
