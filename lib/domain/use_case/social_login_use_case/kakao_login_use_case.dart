import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/result.dart';
import 'package:frontend/core/utils/notification_controller.dart';
import 'package:frontend/domain/model/social_login_result.dart';
import 'package:frontend/domain/repository/on_boarding_repository/on_boarding_repository.dart';
import 'package:frontend/domain/repository/server_login_repository.dart';
import 'package:frontend/domain/repository/social_login_repository/kakao_login_repository.dart';
import 'package:frontend/domain/repository/token_repository.dart';
import 'package:frontend/domain/use_case/dark_mode/dark_mode_use_case.dart';
import 'package:frontend/domain/use_case/push_message/push_message_use_case.dart';
import 'package:frontend/domains/notification/provider/notification_provider.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoLoginUseCase {
  final KakaoLoginRepository socialLoginRepository;
  final ServerLoginRepository serverLoginRepository;
  final TokenRepository tokenRepository;
  final DarkModeUseCase darkModeUseCase;
  final OnBoardingRepository onBoardingRepository;
  final PushMessageUseCase pushMessagePermissionUseCase;

  KakaoLoginUseCase({
    required this.socialLoginRepository,
    required this.serverLoginRepository,
    required this.tokenRepository,
    required this.darkModeUseCase,
    required this.onBoardingRepository,
    required this.pushMessagePermissionUseCase,
  });

  Future<SocialLoginResult> getKakaoSocialId() async {
    //카카오 social id 및 email 얻기
    String email = '';
    String socialId = '';

    final OAuthToken? kakaoLoginResult = await socialLoginRepository.login();
    if (kakaoLoginResult != null) {
      User user = await UserApi.instance.me();

      email = user.kakaoAccount?.email ?? '';
      socialId = '${user.id}';
    }

    return SocialLoginResult(
      email: email,
      socialId: socialId,
    );
  }

  Future<Result<String>> login(String socialId) async {
    //social id를 사용하여 서버에 login
    final loginResult = await loginProcess(socialId);
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
      loginType: 'KAKAO',
      socialId: socialId,
      deviceToken: deviceToken,
      nickname: nickname,
      job: job,
      birthDate: birthDate,
    );

    return result;
  }

  Future<Result<String>> loginProcess(String socialId) async {
    String accessToken = '';

    final container = ProviderContainer();

    var deviceToken = container.read(notificationProvider).token;
    //로그인 api 호출
    final loginResult = await serverLoginRepository.login('KAKAO', socialId, deviceToken);

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

  Future<UserIdResponse?> logout() async {
    await tokenRepository.deleteAllToken();
    onBoardingRepository.clearMyInformation();
    return await socialLoginRepository.logout();
  }

  Future<UserIdResponse?> withdrawal() async {
    await tokenRepository.deleteAllToken();
    await darkModeUseCase.deleteDarkModeData();
    onBoardingRepository.clearMyInformation();
    await pushMessagePermissionUseCase.deletePushMessagePermissionData();
    return await socialLoginRepository.withdrawal();
  }
}
