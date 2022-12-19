import 'package:frontend/core/result.dart';
import 'package:frontend/domain/use_case/on_boarding_use_case/on_boarding_use_case.dart';
import 'package:frontend/presentation/profile/profile_state.dart';
import 'package:get/get.dart';

class ProfileViewModel extends GetxController {
  final OnBoardingUseCase onBoardingUseCase;

  ProfileViewModel({
    required this.onBoardingUseCase,
  });

  final Rx<ProfileState> _state = ProfileState().obs;

  Rx<ProfileState> get state => _state;

  Future<void> getMyInformation() async {
    final getMyInformation = await onBoardingUseCase.getMyInformation();

    getMyInformation.when(
      success: (successData) async {
        _state.value = _state.value.copyWith(
          nickname: successData.nickname,
          job: successData.job,
          age: successData.age,
          loginType: successData.loginType,
          email: successData.email,
        );
        return Result.success(successData);
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }
}
