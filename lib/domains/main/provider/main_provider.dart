import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/data/repository/dark_mode/dark_mode_repository_impl.dart';
import 'package:frontend/data/repository/push_messge/push_message_repository_impl.dart';
import 'package:frontend/domain/use_case/dark_mode/dark_mode_use_case.dart';
import 'package:frontend/domain/use_case/push_message/push_message_use_case.dart';
import 'package:frontend/domains/main/model/main_state.dart';
import 'package:frontend/utils/utils.dart';

final mainProvider = StateNotifierProvider<MainNotifier, MainState>((ref) {
  return MainNotifier(
    ref,
    DarkModeUseCase(
      darkModeRepository: DarkModeRepositoryImpl(),
    ),
    PushMessageUseCase(
      pushMessagePermissionRepository: PushMessageRepositoryImpl(),
    ),
  );
});

class MainNotifier extends StateNotifier<MainState> {
  MainNotifier(this.ref, this.darkModeUseCase, this.pushMessagePermissionUseCase)
      : super(
          MainState(
            themeMode: ThemeMode.system,
            pushMessagePermission: false,
            marketingConsentAgree: false,
            pushMessageTime: DateTime(2023, 1, 1, 21, 00),
          ),
        );

  final Ref ref;
  final DarkModeUseCase darkModeUseCase;
  final PushMessageUseCase pushMessagePermissionUseCase;

  ThemeMode? tempThemeMode;

  Future<void> initializeState() async {
    final pushMessagePermission = GlobalUtils.toBoolean(await pushMessagePermissionUseCase.getIsPushMessagePermission());
    final marketingConsentAgree = GlobalUtils.toBoolean(await pushMessagePermissionUseCase.getIsMarketingConsentAgree());
    final pushMessageTime = DateTime.parse(await pushMessagePermissionUseCase.getPushMessageTime() ?? '2023-01-01 21:00:00.000');
    final themeMode = stringToThemeMode(await darkModeUseCase.getIsDarkMode() ?? "ThemeMode.system");

    state = state.copyWith(
      pushMessagePermission: pushMessagePermission,
      marketingConsentAgree: marketingConsentAgree,
      pushMessageTime: pushMessageTime,
      themeMode: themeMode,
    );
  }

  void toggleThemeMode() {
    GlobalUtils.setAnalyticsCustomEvent('Click_ThemeMode_Change');
    darkModeUseCase.setDarkMode(tempThemeMode!.toString());
    state = state.copyWith(themeMode: tempThemeMode!);
  }

  togglePushMessageValue() {
    if (state.pushMessagePermission) {
      state = state.copyWith(pushMessagePermission: false);
      pushMessagePermissionUseCase.setPushMessagePermission(false.toString());
      pushMessagePermissionUseCase.cancelAllNotifications();
    } else {
      state = state.copyWith(pushMessagePermission: true);
      pushMessagePermissionUseCase.setPushMessagePermission(true.toString());
      pushMessagePermissionUseCase.dailyAtTimeNotification(
        Time(
          state.pushMessageTime.hour,
          state.pushMessageTime.minute,
          state.pushMessageTime.second,
        ),
      );
    }
  }

  toggleMarketingConsentCheck() {
    if (state.marketingConsentAgree) {
      GlobalUtils.setAnalyticsCustomEvent('Click_MarketingToggle_Disagree');
      state = state.copyWith(marketingConsentAgree: false);
      pushMessagePermissionUseCase.setMarketingConsentAgree(false.toString());
    } else {
      GlobalUtils.setAnalyticsCustomEvent('Click_MarketingToggle_Agree');
      state = state.copyWith(marketingConsentAgree: true);
      pushMessagePermissionUseCase.setMarketingConsentAgree(true.toString());
    }
  }

  Future<void> setPushMessageTime(String date) async {
    state = state.copyWith(pushMessageTime: DateTime.parse(date));
    await pushMessagePermissionUseCase.setPushMessageTime(date);
  }

  ThemeMode stringToThemeMode(String themeString) {
    switch (themeString) {
      case 'ThemeMode.light':
        return ThemeMode.light;
      case 'ThemeMode.dark':
        return ThemeMode.dark;
      case 'ThemeMode.system':
      default:
        return ThemeMode.system;
    }
  }

  String themeModeToString(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return "라이트 모드";
      case ThemeMode.dark:
        return "다크 모드";
      case ThemeMode.system:
      default:
        return "시스템 설정";
    }
  }

  Future<void> setPushMessagePermission(bool pushMessagePermission) async {
    state = state.copyWith(pushMessagePermission: pushMessagePermission);
  }

  cancelAllNotifications() {
    pushMessagePermissionUseCase.cancelAllNotifications();
  }

  dailyAtTimeNotification(Time alarmTime) {
    pushMessagePermissionUseCase.dailyAtTimeNotification(alarmTime);
  }
}
