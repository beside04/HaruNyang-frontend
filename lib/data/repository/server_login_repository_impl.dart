import 'package:dio/dio.dart';
import 'package:frontend/apis/login_api.dart';
import 'package:frontend/core/result.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/domain/model/login_token_data.dart';
import 'package:frontend/domain/repository/server_login_repository.dart';

class ServerLoginRepositoryImpl implements ServerLoginRepository {
  final LoginApi loginApi = LoginApi(dio: Dio());

  @override
  Future<Result<LoginTokenData>> login(
    loginType,
    socialId,
    deviceId,
  ) async {
    await tokenUseCase.setLoginType(loginType);
    await tokenUseCase.setSocialId(socialId);

    return await loginApi.login(loginType, socialId, deviceId);
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<bool> signup({
    required email,
    required loginType,
    required socialId,
    required deviceToken,
    required nickname,
    required job,
    required birthDate,
  }) async {
    return await loginApi.signup(
      email: email,
      loginType: loginType,
      socialId: socialId,
      deviceId: deviceToken,
      nickname: nickname,
      job: job,
      birthDate: birthDate,
    );
  }
}
