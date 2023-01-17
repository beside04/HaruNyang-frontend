import 'package:frontend/domain/use_case/on_boarding_use_case/on_boarding_use_case.dart';
import 'package:frontend/domain/use_case/token_use_case.dart';
import 'package:frontend/global_controller/on_boarding/on_boarding_state.dart';
import 'package:get/get.dart';

class OnBoardingController extends GetxController {
  final TokenUseCase tokenUseCase;
  final OnBoardingUseCase onBoardingUseCase;

  OnBoardingController({
    required this.tokenUseCase,
    required this.onBoardingUseCase,
  });

  final Rx<OnBoardingState> _state = OnBoardingState().obs;

  Rx<OnBoardingState> get state => _state;

  Future<bool> getMyInformation() async {
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
          return true;
        }
      },
      error: (message) {},
    );

    return false;
  }

  Future<void> putMyInformation(
      {String? nickname, String? job, String? age}) async {
    nickname ??= state.value.nickname;
    job ??= state.value.job;
    age ??= state.value.age;
    await onBoardingUseCase.putMyInformation(
        nickname: nickname, job: job, age: age);
  }
}
