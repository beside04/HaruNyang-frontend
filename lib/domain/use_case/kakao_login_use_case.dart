import 'package:frontend/domain/repository/server_login_repository.dart';
import 'package:frontend/domain/repository/social_login_repository.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoLoginUseCase {
  final SocialLoginRepository socialLoginRepository;
  final ServerLoginRepository serverLoginRepository;

  KakaoLoginUseCase({
    required this.socialLoginRepository,
    required this.serverLoginRepository,
  });

  Future<OAuthToken?> login() async {
    final OAuthToken? result = await socialLoginRepository.login();
    if (result != null) {
      User user = await UserApi.instance.me();
      print('사용자 정보'
          '\n회원번호: ${user.id}'
          '\n이메일: ${user.kakaoAccount?.email}');
      serverLoginRepository.login('KAKAO', '${user.id}');
    }

    return result;
  }

  Future<UserIdResponse?> logout() async {
    return await socialLoginRepository.logout();
  }
}
