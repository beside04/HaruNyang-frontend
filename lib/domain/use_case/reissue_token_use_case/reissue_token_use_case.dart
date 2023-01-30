import 'package:frontend/core/result.dart';
import 'package:frontend/domain/model/login_token_data.dart';
import 'package:frontend/domain/repository/reissue_token/reissue_token_repository.dart';

class ReissueTokenUseCase {
  final ReissueTokenRepository reissueTokenRepository;

  ReissueTokenUseCase({
    required this.reissueTokenRepository,
  });

  Future<Result<LoginTokenData>> call(String refreshToken) async {
    return await reissueTokenRepository.reissueToken(refreshToken);
  }
}
