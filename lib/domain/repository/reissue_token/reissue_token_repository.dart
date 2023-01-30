import 'package:frontend/core/result.dart';
import 'package:frontend/domain/model/login_token_data.dart';

abstract class ReissueTokenRepository {
  Future<Result<LoginTokenData>> reissueToken(String refreshToken);
}
