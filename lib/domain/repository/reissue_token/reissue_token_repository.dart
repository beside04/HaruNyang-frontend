import 'package:frontend/apis/response_result.dart';
import 'package:frontend/domain/model/login_token_data.dart';

abstract class ReissueTokenRepository {
  Future<ResponseResult<LoginTokenData>> reissueToken(String refreshToken);
}
