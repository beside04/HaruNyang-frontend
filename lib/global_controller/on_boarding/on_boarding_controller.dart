import 'package:flutter/cupertino.dart';
import 'package:frontend/core/result.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/domain/use_case/on_boarding_use_case/on_boarding_use_case.dart';
import 'package:frontend/domain/use_case/social_login_use_case/apple_login_use_case.dart';
import 'package:frontend/domain/use_case/social_login_use_case/kakao_login_use_case.dart';
import 'package:frontend/global_controller/on_boarding/on_boarding_state.dart';
import 'package:frontend/presentation/components/toast.dart';
import 'package:get/get.dart';

class OnBoardingController extends GetxController {
  final OnBoardingUseCase onBoardingUseCase;
  final KakaoLoginUseCase kakaoLoginUseCase;
  final AppleLoginUseCase appleLoginUseCase;

  OnBoardingController({
    required this.onBoardingUseCase,
    required this.kakaoLoginUseCase,
    required this.appleLoginUseCase,
  });

  final Rx<OnBoardingState> _state = OnBoardingState().obs;

  Rx<OnBoardingState> get state => _state;

  final isDuplicateNickname = false.obs;
  final nicknameError = Rx<String?>(null);

  Future<Result<bool>> getMyInformation() async {
    bool check = false;
    bool isError = false;
    final myInfo = await onBoardingUseCase.getMyInformation();

    myInfo.when(
      success: (data) async {
        if (data.job != null && data.nickname != null) {
          if (data.job!.isNotEmpty && data.nickname!.isNotEmpty) {
            _state.value = state.value.copyWith(
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
    _state.value = state.value.copyWith(
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
      job: state.value.job,
      age: state.value.age,
      email: state.value.email,
    );

    if (isNicknameError == const Result<bool>.error('중복된 닉네임 입니다.')) {
      isDuplicateNickname.value = true;
      nicknameError.value = '중복된 닉네임 입니다.';
    } else {
      isDuplicateNickname.value = false;
      nicknameError.value = null;

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
    nickname ??= state.value.nickname;
    job ??= state.value.job;
    age ??= state.value.age;
    email ??= state.value.email;

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
