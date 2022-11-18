import 'package:frontend/data/data_source/local_data/local_secure_data_source.dart';
import 'package:frontend/domain/repository/server_login_repository.dart';
import 'package:frontend/domain/repository/social_login_repository.dart';
import 'package:frontend/res/constants.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoLoginUseCase {
  final SocialLoginRepository socialLoginRepository;
  final ServerLoginRepository serverLoginRepository;

  KakaoLoginUseCase({
    required this.socialLoginRepository,
    required this.serverLoginRepository,
  });

  Future<String> login() async {
    final OAuthToken? kakaoLoginResult = await socialLoginRepository.login();
    String accessToken = '';
    if (kakaoLoginResult != null) {
      User user = await UserApi.instance.me();

      final String email = user.kakaoAccount?.email ?? '';
      String socialId = '${user.id}';
      print('사용자 정보'
          '\n회원번호: $socialId'
          '\n이메일: $email');

      final checkMember = await serverLoginRepository.checkMember(socialId);
      if (checkMember == SocialIDCheck.notMember) {
        //가입 되지 않았으므로 회원 가입 프로세스

        //회원가입 api 호출
        final bool result =
            await serverLoginRepository.signup(email, 'KAKAO', socialId);

        if (result) {
          //회원가입 정상 완료되었으니 로그인 프로세스 호출
          accessToken = await loginProcess(socialId);
        } else {
          //회원가입 실패
        }
      } else if (checkMember == SocialIDCheck.existMember) {
        //이미 가입 되었으므로 바로 login
        accessToken = await loginProcess(socialId);
      } else {
        //통신 에러
      }
    }

    return accessToken;
  }

  Future<String> loginProcess(String socialId) async {
    String accessToken = '';
    //로그인 api 호출
    final loginResult = await serverLoginRepository.login('KAKAO', socialId);

    await loginResult.when(
      success: (loginData) async {
        //secure store에 refresh token 저장.
        await LocalSecureDataSource()
            .saveData(refreshTokenKey, loginData.refreshToken);

        print(await LocalSecureDataSource().loadData(refreshTokenKey));
        //access token은 return하기 위해 다른 변수에 저장.
        accessToken = loginData.accessToken;
      },
      error: (message) {
        print(message);
      },
    );

    return accessToken;
  }

  Future<UserIdResponse?> logout() async {
    return await socialLoginRepository.logout();
  }
}
