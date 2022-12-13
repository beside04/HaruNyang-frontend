import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DiaryDetailViewModel extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  final List<double> delays = [-0.9, -0.6, -0.3];
  final RxBool isLoading = false.obs;
  final RxBool isBookmark = false.obs;

  Future<void> updateTestData() async {
    _updateIsLoading(true);
    await Future.delayed(
      const Duration(seconds: 3),
    );
    _updateIsLoading(false);
  }

  void _updateIsLoading(bool currentStatus) {
    isLoading.value = currentStatus;
  }

  void toggleBookmark() {
    isBookmark.value = !isBookmark.value;
  }

  @override
  void onInit() {
    super.onInit();
    updateTestData();

    animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void onClose() {
    animationController.dispose();
    super.dispose();
  }
}
