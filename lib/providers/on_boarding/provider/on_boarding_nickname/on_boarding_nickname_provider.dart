import 'dart:async';

import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/on_boarding/model/on_boarding_nickname/on_boarding_nickname_state.dart';

// class OnBoardingNicknameViewModel extends GetxController {
//   final TextEditingController nicknameEditingController = TextEditingController();
//
//   final RxString nicknameValue = ''.obs;
//   final RxBool isOnKeyboard = false.obs;
//
//   late Rx<StreamSubscription<bool>?> keyboardSubscription = Rx<StreamSubscription<bool>?>(null);
//
//   @override
//   void onInit() {
//     super.onInit();
//     nicknameEditingController.addListener(() {
//       nicknameValue.value = nicknameEditingController.text;
//     });
//
//     var keyboardVisibilityController = KeyboardVisibilityController();
//
//     keyboardSubscription.value = keyboardVisibilityController.onChange.listen((bool visible) {
//       isOnKeyboard.value = visible;
//     });
//   }
//
//   @override
//   void onClose() {
//     nicknameEditingController.dispose();
//     keyboardSubscription.value?.cancel();
//     super.onClose();
//   }
// }

final onBoardingNicknameProvider = StateNotifierProvider<OnBoardingNicknameNotifier, OnBoardingNicknameState>((ref) => OnBoardingNicknameNotifier());

class OnBoardingNicknameNotifier extends StateNotifier<OnBoardingNicknameState> {
  OnBoardingNicknameNotifier() : super(OnBoardingNicknameState());

  StreamSubscription<bool>? keyboardSubscription;

  init() {
    var keyboardVisibilityController = KeyboardVisibilityController();

    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      state = state.copyWith(isOnKeyboard: visible);
    });
  }

  @override
  void dispose() {
    keyboardSubscription?.cancel();
    super.dispose();
  }
}
