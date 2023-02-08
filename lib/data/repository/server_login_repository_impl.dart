import 'package:frontend/core/result.dart';
import 'package:frontend/data/data_source/remote_data/login_api.dart';
import 'package:frontend/domain/model/login_token_data.dart';
import 'package:frontend/domain/repository/server_login_repository.dart';
import 'package:frontend/res/constants.dart';

class ServerLoginRepositoryImpl implements ServerLoginRepository {
  final LoginApi loginApi = LoginApi();

  @override
  Future<Result<LoginTokenData>> login(loginType, socialId, deviceId) async {
    return await loginApi.login(loginType, socialId, deviceId);
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<SocialIDCheck> checkMember(String socialId) async {
    return await loginApi.checkMember(socialId);
  }

  @override
  Future<bool> signup(String email, String loginType, String socialId) async {
    return await loginApi.signup(email, loginType, socialId);
  }
}
