import 'package:frontend/core/result.dart';
import 'package:frontend/domain/model/login_token_data.dart';
import 'package:frontend/res/constants.dart';

abstract class ServerLoginRepository {
  Future<Result<LoginTokenData>> login(
      String loginType, String socialId, String? deviceId);

  Future<void> logout();

  Future<SocialIDCheck> checkMember(String socialId);

  Future<bool> signup(String email, String loginType, String socialId);
}
