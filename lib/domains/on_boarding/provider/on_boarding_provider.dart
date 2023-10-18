import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/core/result.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/domain/use_case/on_boarding_use_case/on_boarding_use_case.dart';
import 'package:frontend/domain/use_case/social_login_use_case/apple_login_use_case.dart';
import 'package:frontend/domain/use_case/social_login_use_case/kakao_login_use_case.dart';
import 'package:frontend/domains/on_boarding/model/on_boarding_state.dart';
import 'package:frontend/domains/splash/model/splash_state.dart';
import 'package:frontend/global_controller/diary/diary_controller.dart';
import 'package:frontend/global_controller/on_boarding/on_boarding_controller.dart';
import 'package:frontend/global_controller/token/token_controller.dart';
import 'package:frontend/main.dart';
import 'package:frontend/presentation/components/dialog_button.dart';
import 'package:frontend/presentation/components/dialog_component.dart';
import 'package:frontend/presentation/components/toast.dart';
import 'package:frontend/res/constants.dart';
import 'package:get/get.dart';
import 'package:store_redirect/store_redirect.dart';

final onBoardingProvider = StateNotifierProvider<OnBoardingNotifier, OnBoardingState>((ref) {
  return OnBoardingNotifier(
    ref,
    onBoardingUseCase,
    kakaoLoginUseCase,
    appleLoginUseCase,
  );
});

class OnBoardingNotifier extends StateNotifier<OnBoardingState> {
  OnBoardingNotifier(this.ref, this.onBoardingUseCase, this.kakaoLoginUseCase, this.appleLoginUseCase) : super(OnBoardingState());

  final Ref ref;
  final OnBoardingUseCase onBoardingUseCase;
  final KakaoLoginUseCase kakaoLoginUseCase;
  final AppleLoginUseCase appleLoginUseCase;

  Future<Result<bool>> getMyInformation() async {
    bool check = false;
    bool isError = false;
    final myInfo = await onBoardingUseCase.getMyInformation();

    myInfo.when(
      success: (data) async {
        if (data.job != null && data.nickname != null) {
          if (data.job!.isNotEmpty && data.nickname!.isNotEmpty) {
            state = state.copyWith(
              job: data.job!,
              age: data.age,
              nickname: data.nickname!,
              email: data.email,
              loginType: await tokenUseCase.getLoginType(),
            );
            check = true;
          }
        }
      },
      error: (message) {
        isError = true;
      },
    );
    if (isError) {
      return const Result.error('401');
    } else {
      return Result.success(check);
    }
  }

  void clearMyInformation() {
    state = state.copyWith(
      job: '',
      age: '',
      socialId: '',
      nickname: '',
      loginType: '',
    );
  }

  Future<void> putNickname({
    required String nickname,
    required bool isOnBoarding,
    required BuildContext context,
  }) async {
    Result<bool> isNicknameError = await onBoardingUseCase.putMyInformation(
      nickname: nickname,
      job: state.job,
      age: state.age,
      email: state.email,
    );

    if (isNicknameError == const Result<bool>.error('중복된 닉네임 입니다.')) {
      // isDuplicateNickname.value = true;
      // nicknameError.value = '중복된 닉네임 입니다.';
    } else {
      // isDuplicateNickname.value = false;
      // nicknameError.value = null;

      // ignore: use_build_context_synchronously
      toast(
        context: context,
        text: '변경을 완료했어요.',
        isCheckIcon: true,
      );
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }

  Future<void> putMyInformation({
    String? nickname,
    String? job,
    String? age,
    String? email,
    required bool isPutNickname,
    required bool isOnBoarding,
    BuildContext? context,
  }) async {
    nickname ??= state.nickname;
    job ??= state.job;
    age ??= state.age;
    email ??= state.email;

    isPutNickname
        ? await putNickname(
            nickname: nickname,
            isOnBoarding: isOnBoarding,
            context: context!,
          )
        : await onBoardingUseCase.putMyInformation(nickname: nickname, job: job, age: age, email: email);

    await getMyInformation();
  }

  Future<bool> postSignUp({
    required email,
    required loginType,
    required socialId,
    required deviceId,
    required nickname,
    required job,
    required birthDate,
  }) async {
    final result = loginType == "KAKAO"
        ? await kakaoLoginUseCase.signup(
            email: email,
            socialId: socialId,
            nickname: nickname,
            deviceToken: deviceId,
            job: job,
            birthDate: birthDate,
          )
        : await appleLoginUseCase.signup(
            email: email,
            socialId: socialId,
            nickname: nickname,
            deviceToken: deviceId,
            job: job,
            birthDate: birthDate,
          );

    return result;
  }
}
