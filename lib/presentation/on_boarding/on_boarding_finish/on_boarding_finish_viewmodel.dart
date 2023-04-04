import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:frontend/domain/use_case/push_message/push_message_use_case.dart';
import 'package:frontend/main_view_model.dart';
import 'package:get/get.dart';

class OnBoardingFinishViewModel extends GetxController {
  final PushMessageUseCase pushMessagePermissionUseCase;

  OnBoardingFinishViewModel({
    required this.pushMessagePermissionUseCase,
  });

  final mainViewController = Get.find<MainViewModel>();

  setPushMessage() {
    pushMessagePermissionUseCase.setPushMessagePermission(true.toString());
    mainViewController.pushMessagePermission.value = true;

    pushMessagePermissionUseCase.dailyAtTimeNotification(
      const Time(21, 0, 0),
    );
  }
}
