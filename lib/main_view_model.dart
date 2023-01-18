import 'package:flutter/material.dart';
import 'package:frontend/core/result.dart';
import 'package:frontend/domain/model/my_information.dart';
import 'package:frontend/domain/use_case/dark_mode/dark_mode_use_case.dart';
import 'package:frontend/domain/use_case/on_boarding_use_case/on_boarding_use_case.dart';
import 'package:frontend/domain/use_case/push_message_permission/push_message_permission_use_case.dart';
import 'package:frontend/domain/use_case/token_use_case.dart';
import 'package:get/get.dart';
import 'presentation/profile/profile_state.dart';

class MainViewModel extends GetxController {
  final TokenUseCase tokenUseCase;
  final OnBoardingUseCase onBoardingUseCase;
  final DarkModeUseCase darkModeUseCase;
  final PushMessagePermissionUseCase pushMessagePermissionUseCase;

  MainViewModel({
    required this.tokenUseCase,
    required this.onBoardingUseCase,
    required this.darkModeUseCase,
    required this.pushMessagePermissionUseCase,
  });

  final Rx<ProfileState> _state = ProfileState().obs;

  Rx<ProfileState> get state => _state;

  String? token;
  RxBool isDarkMode = false.obs;
  final pushMessagePermission = false.obs;

  void toggleTheme() {
    if (isDarkMode.value) {
      ThemeMode.light;
      isDarkMode.value = false;
      darkModeUseCase.setDarkMode(false.toString());
    } else {
      ThemeMode.dark;
      isDarkMode.value = true;
      darkModeUseCase.setDarkMode(true.toString());
    }
  }

  togglePushMessageValue() {
    if (pushMessagePermission.value) {
      pushMessagePermission.value = false;
      pushMessagePermissionUseCase.setPushMessagePermission(false.toString());
    } else {
      pushMessagePermission.value = true;
      pushMessagePermissionUseCase.setPushMessagePermission(true.toString());
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

  bool toBoolean(String? str) {
    if (str == 'true') {
      return true;
    }
    return false;
  }

  Future<void> getIsDarkMode() async {
    isDarkMode.value = (toBoolean(await darkModeUseCase.getIsDarkMode()));
  }

  Future<void> getIsPushMessage() async {
    pushMessagePermission.value = (toBoolean(
        await pushMessagePermissionUseCase.getIsPushMessagePermission()));
  }
}
