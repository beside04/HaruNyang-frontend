import 'package:flutter/material.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/core/result.dart';
import 'package:frontend/domain/model/my_information.dart';
import 'package:frontend/domain/use_case/on_boarding_use_case/on_boarding_use_case.dart';
import 'package:frontend/domain/use_case/token_use_case.dart';
import 'package:get/get.dart';

import 'presentation/profile/profile_state.dart';

class MainViewModel extends GetxController {
  final TokenUseCase tokenUseCase;
  final OnBoardingUseCase onBoardingUseCase;

  MainViewModel({
    required this.tokenUseCase,
    required this.onBoardingUseCase,
  });

  final Rx<ProfileState> _state = ProfileState().obs;

  Rx<ProfileState> get state => _state;

  String? token;
  final pushMessageValue = true.obs;
  final lightModeValue = true.obs;
  Rx<ThemeMode> themeMode = ThemeMode.light.obs;

  Rx<bool> get isLightMode => (themeMode.value == ThemeMode.light).obs;

  void toggleTheme() {
    if (themeMode.value == ThemeMode.dark) {
      themeMode.value = ThemeMode.light;
    } else {
      themeMode.value = ThemeMode.dark;
    }
  }

  Future<Result<MyInformation>> getMyInformation() async {
    final getMyInformation = await onBoardingUseCase.getMyInformation();

    return getMyInformation.when(
      success: (successData) async {
        _state.value = state.value.copyWith(
          job: successData.job,
          age: successData.age,
          nickname: successData.nickname,
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

  Future<void> getAccessToken() async {
    token = await tokenUseCase.getAccessToken();
  }

  togglePushMessageValue() {
    pushMessageValue.value = !pushMessageValue.value;
  }

// toggleLightModeValue() {
//   lightModeValue.value = !lightModeValue.value;
//   lightModeValue.value
//       ? Get.changeTheme(lightMode)
//       : Get.changeTheme(darkMode);
// }
}
