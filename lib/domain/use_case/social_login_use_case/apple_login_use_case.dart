import 'package:frontend/core/result.dart';
import 'package:frontend/data/data_source/local_data/local_secure_data_source.dart';
import 'package:frontend/domain/model/social_login_result.dart';
import 'package:frontend/domain/repository/server_login_repository.dart';
import 'package:frontend/domain/repository/social_login_repository/apple_login_repository.dart';
import 'package:frontend/res/constants.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleLoginUseCase {
  final AppleLoginRepository socialLoginRepository;
  final ServerLoginRepository serverLoginRepository;

  AppleLoginUseCase({
    required this.socialLoginRepository,
    required this.serverLoginRepository,
  });

  Future<SocialLoginResult> getAppleSocialId() async {
    //애플 social id 및 email 얻기
    String? email = '';
    String? socialId = '';

    final AuthorizationCredentialAppleID? appleLoginResult =
        await socialLoginRepository.login();
    if (appleLoginResult != null) {
      final AuthorizationCredentialAppleID user = appleLoginResult;

      email = user.email;
      socialId = user.userIdentifier;
    }

    return SocialLoginResult(
      email: email ?? '',
      socialId: socialId!,
    );
  }

  Future<SocialIDCheck> checkMember(String socialId) async {
    //멤버 조회
    return await serverLoginRepository.checkMember(socialId);
  }

  Future<Result<String>> login(String socialId) async {
    //social id를 사용하여 서버에 login
    final loginResult = await loginProcess(socialId);
    return loginResult;
  }

  Future<bool> signup(String email, String socialId) async {
    //social id를 사용하여 회원 가입
    final bool result =
        await serverLoginRepository.signup(email, 'APPLE', socialId);

    return result;
  }

  Future<Result<String>> loginProcess(String socialId) async {
    String accessToken = '';
    //로그인 api 호출
    final loginResult = await serverLoginRepository.login('APPLE', socialId);

    return await loginResult.when(
      success: (loginData) async {
        //secure store에 refresh token 저장.
        await LocalSecureDataSource()
            .saveData(refreshTokenKey, loginData.refreshToken);

        //access token은 return하기 위해 다른 변수에 저장.
        accessToken = loginData.accessToken;
        return Result.success(accessToken);
      },
      error: (message) {
        //로그인 에러 처리
        return Result.error(message);
      },
    );
  }
}
