import 'package:frontend/data/data_source/remote_data/login_api.dart';
import 'package:frontend/domain/repository/server_login_repository.dart';

class ServerLoginRepositoryImpl implements ServerLoginRepository {
  final LoginApi loginApi = LoginApi();

  @override
  Future<void> login(loginType, socialId) async {
    return await loginApi.login(loginType, socialId);
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<bool> checkMember(String socialId) async {
    return await loginApi.checkMember(socialId);
  }

  @override
  Future<bool> signup(String email, String loginType, String socialId) async {
    return await loginApi.signup(email, loginType, socialId);
  }
}
