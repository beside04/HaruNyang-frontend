import 'package:flutter/material.dart';
import 'package:frontend/domain/use_case/wise_saying_use_case/get_wise_saying_use_case.dart';
import 'package:get/get.dart';

class DiaryDetailViewModel extends GetxController
    with GetSingleTickerProviderStateMixin {
  final GetWiseSayingUseCase getWiseSayingUseCase;
  final int emoticonId;
  final String diaryContents;

  DiaryDetailViewModel({
    required this.getWiseSayingUseCase,
    required this.emoticonId,
    required this.diaryContents,
  });

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
    //updateTestData();

    getWiseSayingList(emoticonId, diaryContents);

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

  Future<void> getWiseSayingList(int emoticonId, String content) async {
    _updateIsLoading(true);

    final result = await getWiseSayingUseCase(emoticonId, content);

    result.when(
      success: (wiseSayingList) {
        print(wiseSayingList);
      },
      error: (message) {
        print(message);
      },
    );

    _updateIsLoading(false);
  }
}
