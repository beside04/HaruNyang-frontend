import 'package:frontend/apis/response_result.dart';
import 'package:frontend/domain/model/login_token_data.dart';

abstract class ServerLoginRepository {
  Future<ResponseResult<LoginTokenData>> login(String loginType, String socialId, String? deviceId);

  Future<void> logout();

  Future<bool> signup({
    required email,
    required loginType,
    required socialId,
    required deviceToken,
    required nickname,
    required job,
    required birthDate,
  });
}
