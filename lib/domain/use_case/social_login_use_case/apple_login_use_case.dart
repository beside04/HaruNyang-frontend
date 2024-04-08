import 'dart:convert';

import 'package:frontend/core/result.dart';
import 'package:frontend/data/data_source/local_data/auto_diary_save_data_source.dart';
import 'package:frontend/domain/model/social_login_result.dart';
import 'package:frontend/domain/repository/on_boarding_repository/on_boarding_repository.dart';
import 'package:frontend/domain/repository/server_login_repository.dart';
import 'package:frontend/domain/repository/social_login_repository/apple_login_repository.dart';
import 'package:frontend/domain/repository/token_repository.dart';
import 'package:frontend/domain/use_case/dark_mode/dark_mode_use_case.dart';
import 'package:frontend/domain/use_case/push_message/push_message_use_case.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleLoginUseCase {
  final AppleLoginRepository socialLoginRepository;
  final ServerLoginRepository serverLoginRepository;
  final TokenRepository tokenRepository;
  final DarkModeUseCase darkModeUseCase;
  final OnBoardingRepository onBoardingRepository;
  final PushMessageUseCase pushMessagePermissionUseCase;

  AppleLoginUseCase({
    required this.socialLoginRepository,
    required this.serverLoginRepository,
    required this.tokenRepository,
    required this.darkModeUseCase,
    required this.onBoardingRepository,
    required this.pushMessagePermissionUseCase,
  });

  Future<SocialLoginResult> getAppleSocialId() async {
    //애플 social id 및 email 얻기
    String? email = '';
    String? socialId = '';

    final AuthorizationCredentialAppleID? appleLoginResult = await socialLoginRepository.login();
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

  Future<Result<String>> login(String socialId, deviceToken) async {
    //social id를 사용하여 서버에 login
    final loginResult = await loginProcess(socialId, deviceToken);
    return loginResult;
  }

  Future<bool> signup({
    required String? email,
    required String socialId,
    String? deviceToken,
    required String nickname,
    required String job,
    required String birthDate,
  }) async {
    //social id를 사용하여 회원 가입
    final bool result = await serverLoginRepository.signup(
      email: email,
      loginType: 'APPLE',
      socialId: socialId,
      deviceToken: deviceToken,
      nickname: nickname,
      job: job,
      birthDate: birthDate,
    );

    return result;
  }

  Future<Result<String>> loginProcess(String socialId, deviceToken) async {
    String accessToken = '';

    //로그인 api 호출
    final loginResult = await serverLoginRepository.login('APPLE', socialId, deviceToken);

    return await loginResult.when(
      success: (loginData) async {
        await tokenRepository.setAccessToken(loginData.accessToken);
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
    onBoardingRepository.clearMyInformation();
    await AutoDiarySaveDataSource().deleteAllDiary();
    return await socialLoginRepository.logout();
  }

  Future<void> withdrawal() async {
    await tokenRepository.deleteAllToken();
    onBoardingRepository.clearMyInformation();
    await darkModeUseCase.deleteDarkModeData();
    await AutoDiarySaveDataSource().deleteAllDiary();
    await pushMessagePermissionUseCase.deletePushMessagePermissionData();
    await pushMessagePermissionUseCase.deleteMarketingConsentAgree();
    await pushMessagePermissionUseCase.deletePushMessageTime();

    return await socialLoginRepository.withdrawal();
  }
}
