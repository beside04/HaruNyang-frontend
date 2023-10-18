import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/utils/utils.dart';
import 'package:frontend/data/repository/dark_mode/dark_mode_repository_impl.dart';
import 'package:frontend/data/repository/push_messge/push_message_repository_impl.dart';
import 'package:frontend/domain/use_case/dark_mode/dark_mode_use_case.dart';
import 'package:frontend/domain/use_case/push_message/push_message_use_case.dart';
import 'package:frontend/domains/main/model/main_state.dart';

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

  void toggleThemeMode(context) {
    if (state.themeMode == ThemeMode.dark) {
      GlobalUtils.setAnalyticsCustomEvent('Click_ThemeMode_DarkToLight');
      state = state.copyWith(themeMode: ThemeMode.light);
    } else {
      GlobalUtils.setAnalyticsCustomEvent('Click_ThemeMode_LightToDark');
      state = state.copyWith(themeMode: ThemeMode.dark);
    }
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

  Future<void> getIsPushMessage() async {
    state = state.copyWith(pushMessagePermission: (GlobalUtils.toBoolean(await pushMessagePermissionUseCase.getIsPushMessagePermission())));
  }

  Future<void> getIsMarketingConsentAgree() async {
    state = state.copyWith(marketingConsentAgree: (GlobalUtils.toBoolean(await pushMessagePermissionUseCase.getIsMarketingConsentAgree())));
  }

  Future<void> setPushMessageTime(String date) async {
    state = state.copyWith(pushMessageTime: DateTime.parse(date));
    await pushMessagePermissionUseCase.setPushMessageTime(date);
  }

  Future<void> getPushMessageTime() async {
    state = state.copyWith(pushMessageTime: DateTime.parse(await pushMessagePermissionUseCase.getPushMessageTime() ?? '2023-01-01 21:00:00.000'));
  }

  Future<void> setPushMessagePermission(bool pushMessagePermission) async {
    state = state.copyWith(pushMessagePermission: pushMessagePermission);
  }
}
