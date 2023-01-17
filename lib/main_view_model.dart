import 'package:flutter/material.dart';
import 'package:frontend/domain/use_case/dark_mode/dark_mode_use_case.dart';
import 'package:frontend/domain/use_case/token_use_case.dart';
import 'package:get/get.dart';

class MainViewModel extends GetxController {
  final TokenUseCase tokenUseCase;
  final DarkModeUseCase darkModeUseCase;

  MainViewModel({
    required this.tokenUseCase,
    required this.darkModeUseCase,
  });

  String? token;
  RxBool isDarkMode = false.obs;
  final pushMessageValue = true.obs;

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

  togglePushMessageValue() {
    pushMessageValue.value = !pushMessageValue.value;
  }
}
