import 'package:flutter/cupertino.dart';
import 'package:frontend/core/result.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/domain/use_case/on_boarding_use_case/on_boarding_use_case.dart';
import 'package:frontend/domain/use_case/reissue_token_use_case/reissue_token_use_case.dart';
import 'package:frontend/global_controller/on_boarding/on_boarding_state.dart';
import 'package:frontend/presentation/components/toast.dart';
import 'package:frontend/presentation/on_boarding/on_boarding_age/on_boarding_age_screen.dart';
import 'package:get/get.dart';

class OnBoardingController extends GetxController {
  final OnBoardingUseCase onBoardingUseCase;
  final ReissueTokenUseCase reissueTokenUseCase;

  OnBoardingController({
    required this.onBoardingUseCase,
    required this.reissueTokenUseCase,
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
      success: (data) {
        if (data.job != null && data.nickname != null && data.age != null) {
          if (data.job!.isNotEmpty &&
              data.nickname!.isNotEmpty &&
              data.age!.isNotEmpty) {
            _state.value = state.value.copyWith(
              job: data.job!,
              age: data.age!,
              nickname: data.nickname!,
              loginType: data.loginType,
              email: data.email,
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

  Future<bool> reissueToken(String refreshToken) async {
    bool result = false;
    final newToken = await reissueTokenUseCase(refreshToken);
    await newToken.when(
      success: (data) async{
        await tokenUseCase.setAccessToken(data.accessToken);
        await tokenUseCase.setRefreshToken(data.refreshToken);
        result = true;
      },
      error: (message) {},
    );

    return result;
  }
}
