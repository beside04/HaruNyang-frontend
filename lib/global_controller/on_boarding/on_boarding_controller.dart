import 'package:flutter/cupertino.dart';
import 'package:frontend/core/result.dart';
import 'package:frontend/domain/use_case/on_boarding_use_case/on_boarding_use_case.dart';
import 'package:frontend/global_controller/on_boarding/on_boarding_state.dart';
import 'package:frontend/presentation/components/toast.dart';
import 'package:frontend/presentation/on_boarding/on_boarding_age/on_boarding_age_screen.dart';
import 'package:get/get.dart';

class OnBoardingController extends GetxController {
  final OnBoardingUseCase onBoardingUseCase;

  OnBoardingController({
    required this.onBoardingUseCase,
  });

  final Rx<OnBoardingState> _state = OnBoardingState().obs;

  Rx<OnBoardingState> get state => _state;

  final isDuplicateNickname = false.obs;
  final nicknameError = Rx<String?>(null);
  Future<bool> getMyInformation({bool isMoveToLoginPage = true}) async {
    bool check = false;
    final myInfo = await onBoardingUseCase.getMyInformation();

    myInfo.when(
      success: (data) {
        if (data.job != null && data.nickname != null && data.age != null) {
          _state.value = state.value.copyWith(
            job: data.job!,
            age: data.age!,
            nickname: data.nickname!,
            loginType: data.loginType,
            email: data.email,
          );
          check = true;
        }
      },
      error: (message) {},
    );

    return check;
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
    );

    if (isNicknameError == const Result<bool>.error('중복된 닉네임 입니다.')) {
      isDuplicateNickname.value = true;
      nicknameError.value = '중복된 닉네임 입니다.';
    } else {
      isDuplicateNickname.value = false;
      nicknameError.value = null;

      if (isOnBoarding) {
        Get.to(() => OnBoardingAgeScreen(
              nickname: nickname,
            ));
      } else {
        toast(
          context: context,
          text: '변경을 완료했어요.',
          isCheckIcon: true,
        );
        Get.back();
      }
    }
  }

  Future<void> putMyInformation({
    String? nickname,
    String? job,
    String? age,
    required bool isPutNickname,
    required bool isOnBoarding,
    BuildContext? context,
  }) async {
    nickname ??= state.value.nickname;
    job ??= state.value.job;
    age ??= state.value.age;

    isPutNickname
        ? await putNickname(
            nickname: nickname,
            isOnBoarding: isOnBoarding,
            context: context!,
          )
        : await onBoardingUseCase.putMyInformation(
            nickname: nickname, job: job, age: age);

    await getMyInformation();
  }
}
