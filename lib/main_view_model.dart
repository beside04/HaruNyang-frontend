import 'package:flutter/material.dart';
import 'package:frontend/core/utils/utils.dart';
import 'package:frontend/domain/use_case/dark_mode/dark_mode_use_case.dart';
import 'package:frontend/domain/use_case/push_message/push_message_use_case.dart';
import 'package:get/get.dart';

class MainViewModel extends GetxController {
  final DarkModeUseCase darkModeUseCase;
  final PushMessageUseCase pushMessagePermissionUseCase;

  MainViewModel({
    required this.darkModeUseCase,
    required this.pushMessagePermissionUseCase,
  });

  RxBool isDarkMode = false.obs;
  final pushMessagePermission = false.obs;
  final marketingConsentAgree = false.obs;
  final pushMessageTime = DateTime(2023, 1, 1, 21, 00).obs;

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

  toggleMarketingConsentCheck() {
    if (marketingConsentAgree.value) {
      marketingConsentAgree.value = false;
      pushMessagePermission.value = false;
      pushMessagePermissionUseCase.setMarketingConsentAgree(false.toString());
    } else {
      marketingConsentAgree.value = true;
      pushMessagePermission.value = true;
      pushMessagePermissionUseCase.setMarketingConsentAgree(true.toString());
    }
  }

  Future<void> getIsDarkMode() async {
    isDarkMode.value =
        (GlobalUtils.toBoolean(await darkModeUseCase.getIsDarkMode()));
  }

  Future<void> getIsPushMessage() async {
    pushMessagePermission.value = (GlobalUtils.toBoolean(
        await pushMessagePermissionUseCase.getIsPushMessagePermission()));
  }

  Future<void> getIsMarketingConsentAgree() async {
    marketingConsentAgree.value = (GlobalUtils.toBoolean(
        await pushMessagePermissionUseCase.getIsMarketingConsentAgree()));
  }

  Future<void> getPushMessageTime() async {
    pushMessageTime.value = DateTime.parse(
        await pushMessagePermissionUseCase.getPushMessageTime() ??
            '2023-01-01 21:00:00.000');
  }
}
