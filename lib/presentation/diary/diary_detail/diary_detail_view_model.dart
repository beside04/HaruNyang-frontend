import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:frontend/domain/model/wise_saying/wise_saying_data.dart';
import 'package:frontend/domain/use_case/upload/file_upload_use_case.dart';
import 'package:frontend/domain/use_case/wise_saying_use_case/get_wise_saying_use_case.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';

class DiaryDetailViewModel extends GetxController
    with GetSingleTickerProviderStateMixin {
  final GetWiseSayingUseCase getWiseSayingUseCase;
  final FileUploadUseCase fileUploadUseCase;

  final int emoticonId;
  final String diaryContents;
  final CroppedFile? imageFile;

  DiaryDetailViewModel({
    required this.getWiseSayingUseCase,
    required this.fileUploadUseCase,
    required this.emoticonId,
    required this.diaryContents,
    this.imageFile,
  });

  late AnimationController animationController;
  final List<double> delays = [-0.9, -0.6, -0.3];
  List<WiseSayingData> wiseSayingList = [];
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
    diarySave();
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
      success: (result) {
        wiseSayingList = List.from(result);
      },
      error: (message) {
        Get.snackbar('알림', '명언을 불러오는데 실패했습니다.');
      },
    );

    _updateIsLoading(false);
  }

  Future<void> diarySave() async {
    String file = '';
    if (imageFile != null) {
      //이미지 파일이 있다면 이미지 파일 업로드 먼저 실행
      file = await fileUpload();
      if (file.isEmpty) {
        Get.snackbar('알림', '이미지 파일 업로드에 실패했습니다.');
        return;
      }
    }
    //다이어리 저장
  }

  Future<String> fileUpload() async {
    String imageResult = '';
    Uint8List bytes = await imageFile!.readAsBytes();
    String fileName = imageFile!.path.split('/').last;
    final result = await fileUploadUseCase(bytes, fileName);
    result.when(
      success: (fileResult) {
        imageResult = fileResult;
      },
      error: (message) {},
    );
    return imageResult;
  }
}
