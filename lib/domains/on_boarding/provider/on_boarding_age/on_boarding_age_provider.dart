import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
//
// class OnBoardingAgeViewModel extends GetxController {
//   final TextEditingController ageEditingController = TextEditingController();
//   final RxString ageValue = ''.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     ageEditingController.addListener(() {
//       ageValue.value = ageEditingController.text;
//     });
//   }
//
//   @override
//   void onClose() {
//     ageEditingController.dispose();
//     super.onClose();
//   }
//
//   void getBirthDateFormat(date) {
//     ageEditingController.text = DateFormat('yyyy-MM-dd').format(date);
//   }
// }

final onBoardingAgeProvider = StateNotifierProvider<OnBoardingAgeNotifier, String>((ref) => OnBoardingAgeNotifier());

class OnBoardingAgeNotifier extends StateNotifier<String> {
  OnBoardingAgeNotifier() : super('');

  final ageEditingController = TextEditingController();

  void getBirthDateFormat(DateTime date) {
    ageEditingController.text = DateFormat('yyyy-MM-dd').format(date);
    state = ageEditingController.text;
  }
}
