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

      final String email = user.kakaoAccount?.email ?? '';
      String socialId = '${user.id}';
      print('사용자 정보'
          '\n회원번호: $socialId'
          '\n이메일: $email');

      socialId='5';
      //checkMember : true면 가입되지 않은 회원, false면 이미 가입된 회원
      final checkMember = await serverLoginRepository.checkMember(socialId);
      if (checkMember) {
        //회원가입 api 호출
        await serverLoginRepository.signup(email, 'KAKAO', socialId);
      } else {
        //로그인 api 호출
        await serverLoginRepository.login('KAKAO', socialId);
      }
      print(checkMember);

      //await serverLoginRepository.login('KAKAO', '${user.id}');
    }

    return result;
  }

  Future<UserIdResponse?> logout() async {
    return await socialLoginRepository.logout();
  }
}
