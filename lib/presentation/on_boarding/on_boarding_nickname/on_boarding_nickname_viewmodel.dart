import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBoardingNicknameViewModel extends GetxController {
  final TextEditingController nicknameEditingController =
      TextEditingController();
  final RxString nicknameValue = ''.obs;

  @override
  void onInit() {
    super.onInit();
    nicknameEditingController.addListener(() {
      nicknameValue.value = nicknameEditingController.text;
    });
  }

  @override
  void onClose() {
    nicknameEditingController.dispose();
    super.onClose();
  }
}
