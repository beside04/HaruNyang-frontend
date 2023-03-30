import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:frontend/domain/use_case/push_message/push_message_use_case.dart';
import 'package:get/get.dart';

class PushMessageViewModel extends GetxController {
  final PushMessageUseCase pushMessagePermissionUseCase;

  PushMessageViewModel({
    required this.pushMessagePermissionUseCase,
  });

  cancelAllNotifications() {
    pushMessagePermissionUseCase.cancelAllNotifications();
  }

  dailyAtTimeNotification(Time alarmTime) {
    pushMessagePermissionUseCase.dailyAtTimeNotification(alarmTime);
  }
}
