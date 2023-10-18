import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

class OnBoardingNicknameViewModel extends GetxController {
  final TextEditingController nicknameEditingController =
      TextEditingController();

  final RxString nicknameValue = ''.obs;
  final RxBool isOnKeyboard = false.obs;

  late Rx<StreamSubscription<bool>?> keyboardSubscription =
      Rx<StreamSubscription<bool>?>(null);

  @override
  void onInit() {
    super.onInit();
    nicknameEditingController.addListener(() {
      nicknameValue.value = nicknameEditingController.text;
    });

    var keyboardVisibilityController = KeyboardVisibilityController();

    keyboardSubscription.value =
        keyboardVisibilityController.onChange.listen((bool visible) {
      isOnKeyboard.value = visible;
    });
  }

  @override
  void onClose() {
    nicknameEditingController.dispose();
    keyboardSubscription.value?.cancel();
    super.onClose();
  }
}
