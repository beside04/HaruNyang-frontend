import 'dart:convert';

import 'package:frontend/core/result.dart';
import 'package:frontend/domain/model/social_login_result.dart';
import 'package:frontend/domain/repository/server_login_repository.dart';
import 'package:frontend/domain/repository/social_login_repository/apple_login_repository.dart';
import 'package:frontend/domain/repository/token_repository.dart';
import 'package:frontend/domain/use_case/dark_mode/dark_mode_use_case.dart';
import 'package:frontend/domain/use_case/on_boarding_use_case/on_boarding_use_case.dart';
import 'package:frontend/res/constants.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleLoginUseCase {
  final AppleLoginRepository socialLoginRepository;
  final ServerLoginRepository serverLoginRepository;
  final TokenRepository tokenRepository;
  final OnBoardingUseCase onBoardingUseCase;
  final DarkModeUseCase darkModeUseCase;

  AppleLoginUseCase({
    required this.socialLoginRepository,
    required this.serverLoginRepository,
    required this.tokenRepository,
    required this.onBoardingUseCase,
    required this.darkModeUseCase,
  });

  Future<SocialLoginResult> getAppleSocialId() async {
    //애플 social id 및 email 얻기
    String? email = '';
    String? socialId = '';

    final AuthorizationCredentialAppleID? appleLoginResult =
        await socialLoginRepository.login();
    if (appleLoginResult != null) {
      final AuthorizationCredentialAppleID user = appleLoginResult;

      if (user.email != null) {
        email = user.email;
      } else {
        List<String> jwt = user.identityToken?.split('.') ?? [];
        String payload = jwt[1];
        payload = base64.normalize(payload);

        final List<int> jsonData = base64.decode(payload);
        final userInfo = jsonDecode(utf8.decode(jsonData));
        email = userInfo['email'];
      }
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
        await tokenRepository.setAccessToken(loginData.accessToken);
        await tokenRepository.setRefreshToken(loginData.refreshToken);
        return Result.success(accessToken);
      },
      error: (message) {
        //로그인 에러 처리
        return Result.error(message);
      },
    );
  }

  Future<void> logout() async {
    await tokenRepository.deleteAllToken();
    onBoardingUseCase.clearMyInformation();
    return await socialLoginRepository.logout();
  }

  Future<void> withdrawal() async {
    await tokenRepository.deleteAllToken();
    onBoardingUseCase.clearMyInformation();
    return await socialLoginRepository.withdrawal();
  }
}
