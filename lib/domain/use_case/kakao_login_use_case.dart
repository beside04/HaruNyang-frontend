import 'package:frontend/domain/repository/social_login_repository.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoLoginUseCase {
  final SocialLoginRepository repository;

  KakaoLoginUseCase({
    required this.repository,
  });

  Future<OAuthToken?> login() async {
    final OAuthToken? result = await repository.login();
    if (result != null) {
      print('check access token : ${result.accessToken}');
      print('check refresh token : ${result.refreshToken}');
      User user = await UserApi.instance.me();
      print('사용자 정보'
          '\n회원번호: ${user.id}'
          '\n이메일: ${user.kakaoAccount?.email}');
    }

    return result;
  }

  Future<UserIdResponse?> logout() async {
    return await repository.logout();
  }
}
