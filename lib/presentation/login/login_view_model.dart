import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/domain/use_case/social_login_use_case/apple_login_use_case.dart';
import 'package:frontend/domain/use_case/social_login_use_case/kakao_login_use_case.dart';
import 'package:frontend/global_controller/diary/diary_controller.dart';
import 'package:frontend/global_controller/on_boarding/on_boarding_controller.dart';
import 'package:frontend/presentation/home/home_screen.dart';
import 'package:frontend/presentation/login/login_state.dart';
import 'package:frontend/presentation/login/login_terms_information/login_terms_information_screen.dart';
import 'package:frontend/presentation/sign_in_complete/sign_in_complete_screen.dart';
import 'package:get/get.dart';

class LoginViewModel extends GetxController {
  final KakaoLoginUseCase kakaoLoginUseCase;
  final AppleLoginUseCase appleLoginUseCase;

  LoginViewModel({
    required this.kakaoLoginUseCase,
    required this.appleLoginUseCase,
  });

  final Rx<LoginState> _state = LoginState().obs;

  Rx<LoginState> get state => _state;

  Future<void> connectKakaoLogin() async {
    //social id 얻기
    final isSocialIdGet = await getSocialId(isSocialKakao: true);
    if (!isSocialIdGet) {
      Get.snackbar('알림', '카카오 세션과 연결이 실패했습니다.');
      return;
    }

    final loginResult = await onLogin(isSocialKakao: true);

    if (loginResult == 200) {
      await loginDone();
    } else if (loginResult == 404) {
      Get.to(
        () => const LoginTermsInformationScreen(isSocialKakao: true),
      );
    }

    // //멤버 조회
    // final checkMemberResult =
    //     await kakaoLoginUseCase.checkMember(state.value.socialId);

    // //조회 결과
    // switch (checkMemberResult) {
    //   case SocialIDCheck.existMember:
    //     //로그인
    //     final loginResult = await _onLogin(isSocialKakao: true);
    //     if (loginResult) {
    //       await _loginDone();
    //     }
    //     break;
    //   case SocialIDCheck.notMember:
    //     _state.value = state.value.copyWith(
    //       isSocialKakao: true,
    //     );
    //
    //     //멤버가 아니면 약관 동의 페이지 이동
    //     Get.to(
    //       () => const LoginTermsInformationScreen(isSocialKakao: true),
    //     );
    //     break;
    //   case SocialIDCheck.error:
    //     Get.snackbar('알림', '서버와의 연결이 실패했습니다.');
    //     return;
    // }
  }

  Future<void> connectAppleLogin() async {
    //social id 얻기
    final isSocialIdGet = await getSocialId(isSocialKakao: false);
    if (!isSocialIdGet) {
      Get.snackbar('알림', '애플 세션과 연결이 실패했습니다.');
      return;
    }

    final loginResult = await onLogin(isSocialKakao: false);
    if (loginResult == 200) {
      await loginDone();
    } else if (loginResult == 404) {
      Get.to(
        () => const LoginTermsInformationScreen(isSocialKakao: false),
      );
    }
    // //멤버 조회
    // final checkMemberResult =
    //     await appleLoginUseCase.checkMember(state.value.socialId);

    //조회 결과
    // switch (checkMemberResult) {
    //   case SocialIDCheck.existMember:
    //     //이미 가입한 회원이므로 로그인
    //     final loginResult = await _onLogin(isSocialKakao: false);
    //     if (loginResult) {
    //       await _loginDone();
    //     }
    //     break;
    //   case SocialIDCheck.notMember:
    //     _state.value = state.value.copyWith(
    //       isSocialKakao: false,
    //     );
    //
    //     //멤버가 아니면 약관 동의 페이지 이동
    //     Get.to(
    //       () => const LoginTermsInformationScreen(isSocialKakao: false),
    //     );
    //     break;
    //   case SocialIDCheck.error:
    //     Get.snackbar('알림', '서버와의 연결이 실패했습니다.');
    //     return;
    // }
  }

  Future<bool> getSocialId({required isSocialKakao}) async {
    final socialLoginResult = isSocialKakao
        ? await kakaoLoginUseCase.getKakaoSocialId()
        : await appleLoginUseCase.getAppleSocialId();
    final email = socialLoginResult.email;
    final socialId = socialLoginResult.socialId;

    if (socialId.isEmpty) {
      return false;
    }

    _state.value = state.value.copyWith(
      socialId: socialId,
      email: email,
      isSocialKakao: isSocialKakao,
    );
    return true;
  }

  Future<void> signupAndLogin(isSocialKakao) async {
    await getSocialId(isSocialKakao: isSocialKakao);

    Get.offAll(
      () => SignInCompleteScreen(
        email: state.value.email,
        loginType: state.value.isSocialKakao == true ? "KAKAO" : "APPLE",
        socialId: state.value.socialId,
      ),
    );

    // if (!result) {
    //   Get.snackbar('알림', '회원가입에 실패했습니다.');
    // } else {
    //   // //회원 가입 완료 되었으므로 로그인
    //   final loginResult =
    //       await onLogin(isSocialKakao: state.value.isSocialKakao);
    //
    //   if (loginResult == 404) {
    //     //회원가입 완료 페이지로 이동
    //     Get.offAll(
    //       () => const SignInCompleteScreen(),
    //     );
    //   } else {
    //     Get.snackbar('알림', '로그인에 실패했습니다.');
    //   }
    // }
  }

  Future<int> onLogin({required isSocialKakao}) async {
    int result = 0;
    final loginResult = isSocialKakao
        ? await kakaoLoginUseCase.login(state.value.socialId)
        : await appleLoginUseCase.login(state.value.socialId);

    await loginResult.when(
      success: (accessToken) async {
        result = 200;
      },
      error: (message) {
        result = int.parse(message);

        if (int.parse(message) == 404) {
          Get.snackbar('알림', '회원가입 되지 않은 유저입니다.');
        } else {
          Get.snackbar('알림', '로그인이 실패했습니다.');
        }
      },
    );

    return result;
  }

  void goHome() {
    Get.offAll(
      () => const HomeScreen(),
      binding: BindingsBuilder(
        getHomeViewModelBinding,
      ),
    );
  }

  Future<void> loginDone() async {
    //캘린더 업데이트
    Get.find<DiaryController>().initPage();

    final getMyInfoResult =
        await Get.find<OnBoardingController>().getMyInformation();

    getMyInfoResult.when(
      success: (data) {},
      error: (message) {},
    );

    Get.find<DiaryController>().getAllBookmarkData();

    goHome();

    // if (isOnBoardingDone) {
    //   //홈으로 이동
    //   goHome();
    // } else {
    //   //온보딩 화면으로 이동
    //   Get.offAll(
    //     () => const OnBoardingNicknameScreen(),
    //   );
    // }
  }
}
