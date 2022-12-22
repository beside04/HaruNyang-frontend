import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OnBoardingAgeViewModel extends GetxController {
  final TextEditingController ageEditingController = TextEditingController();
  final RxString ageValue = ''.obs;

  @override
  void onInit() {
    super.onInit();
    ageEditingController.addListener(() {
      ageValue.value = ageEditingController.text;
    });
  }

  @override
  void onClose() {
    ageEditingController.dispose();
    super.onClose();
  }

  void getBirthDateFormat(date) {
    ageEditingController.text = DateFormat('yyyy-MM-dd').format(date);
  }
}
