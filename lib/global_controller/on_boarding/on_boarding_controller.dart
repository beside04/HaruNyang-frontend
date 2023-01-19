import 'package:frontend/domain/use_case/on_boarding_use_case/on_boarding_use_case.dart';
import 'package:frontend/global_controller/on_boarding/on_boarding_state.dart';
import 'package:get/get.dart';

class OnBoardingController extends GetxController {
  final OnBoardingUseCase onBoardingUseCase;

  OnBoardingController({
    required this.onBoardingUseCase,
  });

  final Rx<OnBoardingState> _state = OnBoardingState().obs;

  Rx<OnBoardingState> get state => _state;

  Future<bool> getMyInformation() async {
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

  Future<void> putMyInformation(
      {String? nickname, String? job, String? age}) async {
    nickname ??= state.value.nickname;
    job ??= state.value.job;
    age ??= state.value.age;
    await onBoardingUseCase.putMyInformation(
        nickname: nickname, job: job, age: age);

    await getMyInformation();
  }
}
