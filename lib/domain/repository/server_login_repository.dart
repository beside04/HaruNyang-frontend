import 'package:frontend/core/result.dart';
import 'package:frontend/domain/model/login_token_data.dart';
import 'package:frontend/res/constants.dart';

abstract class ServerLoginRepository {
  Future<Result<LoginTokenData>> login(
      String loginType, String socialId, String? deviceId);

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
