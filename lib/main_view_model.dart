import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
      GlobalUtils.setAnalyticsCustomEvent('Click_ThemeMode_DarkToLight');
      ThemeMode.light;
      isDarkMode.value = false;
      darkModeUseCase.setDarkMode(false.toString());
    } else {
      GlobalUtils.setAnalyticsCustomEvent('Click_ThemeMode_LightToDark');
      ThemeMode.dark;
      isDarkMode.value = true;
      darkModeUseCase.setDarkMode(true.toString());
    }
  }

  togglePushMessageValue() {
    if (pushMessagePermission.value) {
      pushMessagePermission.value = false;
      pushMessagePermissionUseCase.setPushMessagePermission(false.toString());
      pushMessagePermissionUseCase.cancelAllNotifications();
    } else {
      pushMessagePermission.value = true;
      pushMessagePermissionUseCase.setPushMessagePermission(true.toString());
      pushMessagePermissionUseCase.dailyAtTimeNotification(
        Time(
          pushMessageTime.value.hour,
          pushMessageTime.value.minute,
          pushMessageTime.value.second,
        ),
      );
    }
  }

  toggleMarketingConsentCheck() {
    if (marketingConsentAgree.value) {
      GlobalUtils.setAnalyticsCustomEvent('Click_MarketingToggle_Disagree');
      marketingConsentAgree.value = false;
      pushMessagePermissionUseCase.setMarketingConsentAgree(false.toString());
    } else {
      GlobalUtils.setAnalyticsCustomEvent('Click_MarketingToggle_Agree');
      marketingConsentAgree.value = true;
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

  Future<void> setPushMessageTime(String date) async {
    pushMessageTime.value = DateTime.parse(date);
    await pushMessagePermissionUseCase.setPushMessageTime(date);
  }

  Future<void> getPushMessageTime() async {
    pushMessageTime.value = DateTime.parse(
        await pushMessagePermissionUseCase.getPushMessageTime() ??
            '2023-01-01 21:00:00.000');
  }
}
