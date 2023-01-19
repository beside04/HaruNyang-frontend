import 'package:flutter/material.dart';
import 'package:frontend/domain/use_case/dark_mode/dark_mode_use_case.dart';
import 'package:frontend/domain/use_case/push_message_permission/push_message_permission_use_case.dart';
import 'package:get/get.dart';

class MainViewModel extends GetxController {
  final DarkModeUseCase darkModeUseCase;
  final PushMessagePermissionUseCase pushMessagePermissionUseCase;

  MainViewModel({
    required this.darkModeUseCase,
    required this.pushMessagePermissionUseCase,
  });

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
