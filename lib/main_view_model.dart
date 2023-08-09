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

  @override
  void onInit() {
    super.onInit();
  }

  Rx<ThemeMode> themeMode = ThemeMode.system.obs;
  final pushMessagePermission = false.obs;
  final marketingConsentAgree = false.obs;
  final pushMessageTime = DateTime(2023, 1, 1, 21, 00).obs;

  void toggleThemeMode(context) {
    if (themeMode.value == ThemeMode.dark) {
      GlobalUtils.setAnalyticsCustomEvent('Click_ThemeMode_DarkToLight');
      themeMode.value = ThemeMode.light;
    } else {
      GlobalUtils.setAnalyticsCustomEvent('Click_ThemeMode_LightToDark');
      themeMode.value = ThemeMode.dark;
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
