import 'package:frontend/core/result.dart';
import 'package:frontend/domain/model/my_information.dart';
import 'package:frontend/domain/use_case/on_boarding_use_case/apple_login_use_case.dart';
import 'package:frontend/domain/use_case/social_login_use_case/apple_login_use_case.dart';
import 'package:frontend/domain/use_case/social_login_use_case/kakao_login_use_case.dart';
import 'package:frontend/presentation/home/home_screen.dart';
import 'package:frontend/presentation/login/login_state.dart';
import 'package:frontend/presentation/login/login_terms_information/login_terms_information_screen.dart';
import 'package:frontend/presentation/on_boarding/on_boarding_nickname/on_boarding_nickname_screen.dart';
import 'package:frontend/res/constants.dart';
import 'package:get/get.dart';

class LoginViewModel extends GetxController {
  final KakaoLoginUseCase kakaoLoginUseCase;
  final AppleLoginUseCase appleLoginUseCase;
  final OnBoardingUseCase onBoardingUseCase;

  LoginViewModel({
    required this.kakaoLoginUseCase,
    required this.appleLoginUseCase,
    required this.onBoardingUseCase,
  });

  final Rx<LoginState> _state = LoginState().obs;

  Rx<LoginState> get state => _state;

  Future<void> connectKakaoLogin() async {
    //social id 얻기
    final isSocialIdGet = await _getSocialId(isSocialKakao: true);
    if (!isSocialIdGet) {
      Get.snackbar('알림', '카카오 세션과 연결이 실패했습니다.');
      return;
    }

    //멤버 조회
    final checkMemberResult =
        await kakaoLoginUseCase.checkMember(state.value.socialId);

    //조회 결과
    switch (checkMemberResult) {
      case SocialIDCheck.existMember:
        //로그인
        final loginResult = await _onLogin(isSocialKakao: true);
        if (loginResult) {
          //내정보 조회 API를 통해 온보딩 여부 체크
          final infoResult = await getMyInformation();
          infoResult.when(
            success: (info) {
              if (info.nickname == null ||
                  info.job == null ||
                  info.age == null) {
                //온보딩 미완료했으면 온보딩 화면으로 이동
                Get.offAll(
                  () => const OnBoardingNicknameScreen(),
                );
              } else {
                //온보딩 완료했으면 Home 화면으로 이동
                Get.offAll(
                  () => const HomeScreen(),
                );
              }
            },
            error: (message) {},
          );
        }
        break;
      case SocialIDCheck.notMember:
        _state.value = state.value.copyWith(
          isSocialKakao: true,
        );

        //멤버가 아니면 약관 동의 페이지 이동
        Get.to(
          const LoginTermsInformationScreen(),
        );
        break;
      case SocialIDCheck.error:
        Get.snackbar('알림', '서버와의 연결이 실패했습니다.');
        return;
    }
  }

  Future<void> connectAppleLogin() async {
    //social id 얻기
    final isSocialIdGet = await _getSocialId(isSocialKakao: false);
    if (!isSocialIdGet) {
      Get.snackbar('알림', '애플 세션과 연결이 실패했습니다.');
      return;
    }
    //멤버 조회
    final checkMemberResult =
        await appleLoginUseCase.checkMember(state.value.socialId);

    //조회 결과
    switch (checkMemberResult) {
      case SocialIDCheck.existMember:
        //이미 가입한 회원이므로 로그인
        final loginResult = await _onLogin(isSocialKakao: false);
        if (loginResult) {
          //내정보 조회 API를 통해 온보딩 여부 체크
          final infoResult = await getMyInformation();
          infoResult.when(
            success: (info) {
              if (info.nickname == null ||
                  info.job == null ||
                  info.age == null) {
                //온보딩 미완료했으면 온보딩 화면으로 이동
                Get.offAll(
                  () => const OnBoardingNicknameScreen(),
                );
              } else {
                //온보딩 완료했으면 Home 화면으로 이동
                Get.offAll(
                  () => const HomeScreen(),
                );
              }
            },
            error: (message) {},
          );
        }
        break;
      case SocialIDCheck.notMember:
        _state.value = state.value.copyWith(
          isSocialKakao: false,
        );

        //멤버가 아니면 약관 동의 페이지 이동
        Get.to(
          const LoginTermsInformationScreen(),
        );
        break;
      case SocialIDCheck.error:
        Get.snackbar('알림', '서버와의 연결이 실패했습니다.');
        return;
    }
  }

  Future<bool> _getSocialId({required isSocialKakao}) async {
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
    );
    return true;
  }

  Future<void> signupAndLogin() async {
    //회원가입
    final result = state.value.isSocialKakao
        ? await kakaoLoginUseCase.signup(
            state.value.email, state.value.socialId)
        : await appleLoginUseCase.signup(
            state.value.email, state.value.socialId);
    if (!result) {
      Get.snackbar('알림', '회원가입에 실패했습니다.');
    } else {
      //회원 가입 완료 되었으므로 로그인
      final loginResult =
          await _onLogin(isSocialKakao: state.value.isSocialKakao);
      if (loginResult) {
        //내정보 조회 API를 통해 온보딩 여부 체크
        final infoResult = await getMyInformation();
        infoResult.when(
          success: (info) {
            if (info.nickname == null || info.job == null || info.age == null) {
              //온보딩 미완료했으면 온보딩 화면으로 이동
              Get.offAll(
                () => const OnBoardingNicknameScreen(),
              );
            } else {
              //온보딩 완료했으면 Home 화면으로 이동
              Get.offAll(
                () => const HomeScreen(),
              );
            }
          },
          error: (message) {},
        );
      }
    }
  }

  Future<bool> _onLogin({required isSocialKakao}) async {
    bool result = false;
    final loginResult = isSocialKakao
        ? await kakaoLoginUseCase.login(state.value.socialId)
        : await appleLoginUseCase.login(state.value.socialId);

    await loginResult.when(
      success: (accessToken) async {
        result = true;
      },
      error: (message) {
        Get.snackbar('알림', '로그인이 실패했습니다.');
      },
    );

    return result;
  }

  Future<Result<MyInformation>> getMyInformation() async {
    final getMyInformation = await onBoardingUseCase.getMyInformation();

    return getMyInformation.when(
      success: (successData) async {
        return Result.success(successData);
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }
}
