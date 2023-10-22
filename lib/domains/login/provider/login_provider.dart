import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/domain/use_case/pop_up/pop_up_use_case.dart';
import 'package:frontend/domain/use_case/social_login_use_case/apple_login_use_case.dart';
import 'package:frontend/domain/use_case/social_login_use_case/kakao_login_use_case.dart';
import 'package:frontend/domains/diary/provider/diary_provider.dart';
import 'package:frontend/domains/login/model/login_state.dart';
import 'package:frontend/domains/on_boarding/provider/on_boarding_provider.dart';
import 'package:frontend/main.dart';
import 'package:frontend/res/constants.dart';
import 'package:frontend/ui/screen/home/home_screen.dart';
import 'package:frontend/ui/screen/login/login_terms_information_screen.dart';
import 'package:frontend/ui/screen/sign_in_complete/sign_in_complete_screen.dart';
import 'package:store_redirect/store_redirect.dart';

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  return LoginNotifier(ref);
});

class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier(this.ref) : super(LoginState());

  final Ref ref;

  Future<void> connectKakaoLogin() async {
    //social id 얻기
    final isSocialIdGet = await getSocialId(isSocialKakao: "kakao");
    if (!isSocialIdGet) {
      // Get.snackbar('알림', '카카오 세션과 연결이 실패했습니다.');
      return;
    }

    getLoginSuccessData(loginType: "kakao");
  }

  Future<void> connectAppleLogin() async {
    //social id 얻기
    final isSocialIdGet = await getSocialId(isSocialKakao: "apple");
    if (!isSocialIdGet) {
      // Get.snackbar('알림', '애플 세션과 연결이 실패했습니다.');
      return;
    }

    getLoginSuccessData(loginType: "apple");
  }

  Future<void> getLoginSuccessData({required String loginType}) async {
    final loginResult = await onLogin(loginType: loginType);

    if (loginResult == 200) {
      await loginDone();
    } else if (loginResult == 404) {
      navigatorKey.currentState!.push(
        MaterialPageRoute(
            builder: (context) => LoginTermsInformationScreen(
                  loginType: loginType,
                )),
      );
    }
  }

  Future<bool> getSocialId({required String isSocialKakao}) async {
    final socialLoginResult = isSocialKakao == "kakao" ? await kakaoLoginUseCase.getKakaoSocialId() : await appleLoginUseCase.getAppleSocialId();
    final email = socialLoginResult.email;
    final socialId = socialLoginResult.socialId;

    if (socialId.isEmpty) {
      return false;
    }

    state = state.copyWith(
      socialId: socialId,
      email: email,
    );

    return true;
  }

  Future<void> signupAndLogin(String isSocialKakao) async {
    await getSocialId(isSocialKakao: isSocialKakao);

    navigatorKey.currentState!.pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => SignInCompleteScreen(
                  email: state.email == "" ? null : state.email,
                  loginType: state.loginType,
                  socialId: state.socialId,
                )),
        (route) => false);
  }

  Future<int> onLogin({required loginType}) async {
    int result = 0;
    final loginResult = loginType == "kakao" ? await kakaoLoginUseCase.login(state.socialId) : await appleLoginUseCase.login(state.socialId);

    await loginResult.when(
      success: (accessToken) async {
        result = 200;
      },
      error: (message) {
        result = int.parse(message);

        if (int.parse(message) == 404) {
          // Get.snackbar('알림', '회원가입 되지 않은 유저입니다.');
        } else {
          // Get.snackbar('알림', '로그인이 실패했습니다.');
        }
      },
    );

    return result;
  }

  void goHome() {
    navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);
  }

  Future<void> loginDone() async {
    //캘린더 업데이트

    ref.watch(diaryProvider.notifier).initPage();

    await ref.watch(onBoardingProvider.notifier).getMyInformation();

    ref.watch(diaryProvider.notifier).getAllBookmarkData();

    goHome();
  }

  Future<void> kakaoLogout() async {
    await kakaoLoginUseCase.logout();
  }

  Future<void> appleLogout() async {
    await appleLoginUseCase.logout();
  }
}
