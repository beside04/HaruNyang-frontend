import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/domain/use_case/push_message/push_message_use_case.dart';
import 'package:frontend/domains/main/provider/main_provider.dart';

final onBoardingFinishProvider = StateNotifierProvider<OnBoardingFinishNotifier, bool>((ref) {
  return OnBoardingFinishNotifier(ref, pushMessagePermissionUseCase);
});

class OnBoardingFinishNotifier extends StateNotifier<bool> {
  OnBoardingFinishNotifier(this.ref, this.pushMessagePermissionUseCase) : super(false);

  final Ref ref;
  final PushMessageUseCase pushMessagePermissionUseCase;

  setPushMessage() {
    pushMessagePermissionUseCase.setPushMessagePermission(true.toString());
    ref.watch(mainProvider.notifier).setPushMessagePermission(true);

    pushMessagePermissionUseCase.dailyAtTimeNotification(
      const Time(21, 0, 0),
    );
  }
}

// class OnBoardingFinishViewModel extends GetxController {
//   final PushMessageUseCase pushMessagePermissionUseCase;
//
//   OnBoardingFinishViewModel({
//     required this.pushMessagePermissionUseCase,
//   });
//
//   final mainViewController = Get.find<MainViewModel>();
//
//   setPushMessage() {
//     pushMessagePermissionUseCase.setPushMessagePermission(true.toString());
//     mainViewController.pushMessagePermission.value = true;
//
//     pushMessagePermissionUseCase.dailyAtTimeNotification(
//       const Time(21, 0, 0),
//     );
//   }
// }
