import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:frontend/domain/model/diary/diary_data.dart';
import 'package:frontend/domain/model/wise_saying/wise_saying_data.dart';
import 'package:frontend/domain/use_case/diary/save_diary_use_case.dart';
import 'package:frontend/domain/use_case/upload/file_upload_use_case.dart';
import 'package:frontend/domain/use_case/wise_saying_use_case/get_wise_saying_use_case.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';

class DiaryDetailViewModel extends GetxController
    with GetSingleTickerProviderStateMixin {
  final GetWiseSayingUseCase getWiseSayingUseCase;
  final FileUploadUseCase fileUploadUseCase;
  final SaveDiaryUseCase saveDiaryUseCase;

  final DiaryData diaryData;
  final CroppedFile? imageFile;
  final bool isStamp;

  DiaryDetailViewModel({
    required this.getWiseSayingUseCase,
    required this.fileUploadUseCase,
    required this.saveDiaryUseCase,
    required this.diaryData,
    required this.isStamp,
    this.imageFile,
  });

  @override
  void onInit() {
    super.onInit();
    networkImage.value = '';
    if (!isStamp) {
      diarySave(diaryData);
    } else {
      wiseSayingList.value = diaryData.wiseSayings;
      networkImage.value = diaryData.images.first;
    }

    animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  late AnimationController animationController;
  final List<double> delays = [-0.9, -0.6, -0.3];
  RxList<WiseSayingData> wiseSayingList = <WiseSayingData>[].obs;
  RxString networkImage = ''.obs;
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
  void onClose() {
    animationController.dispose();
    super.dispose();
  }

  Future<void> getWiseSayingList(int emoticonId, String content) async {
    final result = await getWiseSayingUseCase(emoticonId, content);

    result.when(
      success: (result) {
        wiseSayingList.value = List.from(result);
      },
      error: (message) {
        Get.snackbar('알림', '명언을 불러오는데 실패했습니다.');
      },
    );
  }

  Future<void> diarySave(DiaryData diary) async {
    _updateIsLoading(true);
    //이미지 파일이 있다면 이미지 파일 업로드 먼저 실행
    if (imageFile != null) {
      networkImage.value = await fileUpload();
      if (networkImage.isEmpty) {
        Get.snackbar('알림', '이미지 파일 업로드에 실패했습니다.');
      }
    } else if (diaryData.images.isNotEmpty) {
      networkImage.value = diaryData.images.first;
    }

    //명언 받아오기
    await getWiseSayingList(diary.emotion.id!, diary.diaryContent);

    //다이어리 저장
    await saveDiaryUseCase(
      diary.copyWith(
        images: [networkImage.value],
        wiseSayings: wiseSayingList,
      ),
    );
    _updateIsLoading(false);
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
