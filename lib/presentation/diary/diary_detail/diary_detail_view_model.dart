import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:frontend/domain/model/diary/diary_data.dart';
import 'package:frontend/domain/model/wise_saying/wise_saying_data.dart';
import 'package:frontend/domain/use_case/diary/delete_diary_use_case.dart';
import 'package:frontend/domain/use_case/diary/save_diary_use_case.dart';
import 'package:frontend/domain/use_case/diary/update_diary_use_case.dart';
import 'package:frontend/domain/use_case/emotion_stamp_use_case/get_emotion_diary_use_case.dart';
import 'package:frontend/domain/use_case/upload/file_upload_use_case.dart';
import 'package:frontend/domain/use_case/wise_saying_use_case/get_wise_saying_use_case.dart';
import 'package:frontend/presentation/emotion_stamp/emotion_stamp_view_model.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';

class DiaryDetailViewModel extends GetxController
    with GetSingleTickerProviderStateMixin {
  final GetWiseSayingUseCase getWiseSayingUseCase;
  final GetEmotionStampUseCase getEmotionStampUseCase;
  final SaveDiaryUseCase saveDiaryUseCase;
  final UpdateDiaryUseCase updateDiaryUseCase;
  final DeleteDiaryUseCase deleteDiaryUseCase;
  final FileUploadUseCase fileUploadUseCase;

  final DiaryData diaryData;
  final CroppedFile? imageFile;
  final bool isStamp;
  final DateTime date;

  DiaryDetailViewModel({
    required this.getWiseSayingUseCase,
    required this.getEmotionStampUseCase,
    required this.saveDiaryUseCase,
    required this.updateDiaryUseCase,
    required this.deleteDiaryUseCase,
    required this.fileUploadUseCase,
    required this.diaryData,
    required this.isStamp,
    required this.date,
    this.imageFile,
  });

  @override
  void onInit() {
    super.onInit();
    networkImage.value = '';
    setDiary(diaryData);

    if (!isStamp) {
      diarySave(diary.value!);
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
  final Rxn<DiaryData?> diary = Rxn<DiaryData?>();

  Future<void> updateTestData() async {
    _updateIsLoading(true);
    await Future.delayed(
      const Duration(seconds: 3),
    );
    _updateIsLoading(false);
  }

  void setDiary(DiaryData newDiary) {
    diary.value = newDiary.copyWith();
  }

  void _updateIsLoading(bool currentStatus) {
    isLoading.value = currentStatus;
  }

  void toggleBookmark() {
    isBookmark.value = !isBookmark.value;
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

    //새로운 diary Data
    final newDiary = diary.copyWith(
      images: [networkImage.value],
      wiseSayings: wiseSayingList,
      createTime: DateFormat('yyyy-MM-dd').format(date),
    );

    if (diary.id != null) {
      //update 다이어리
      await updateDiaryUseCase(
        newDiary,
      );
    } else {
      //save 다이어리
      final saveDiaryResult = await saveDiaryUseCase(newDiary);
      saveDiaryResult.when(
        success: (data) {},
        error: (message) {
          Get.snackbar(
            '알림',
            message,
          );
        },
      );

      await Get.find<EmotionStampViewModel>().getMonthStartEndData();
      await Get.find<EmotionStampViewModel>().getEmotionStampList();

      final todayDiary = await getEmotionStampUseCase.getTodayDiary();
      todayDiary.when(
        success: (diary) {
          if (diary.isNotEmpty) {
            setDiary(diary.first);
          }
        },
        error: (message) {},
      );
    }
    await Get.find<EmotionStampViewModel>().getMonthStartEndData();
    await Get.find<EmotionStampViewModel>().getEmotionStampList();

    await Future.delayed(
      const Duration(seconds: 1),
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

  Future<void> deleteDiary() async {
    if (diary.value != null) {
      final result = await deleteDiaryUseCase(diary.value!.id!);
      result.when(
        success: (result) async {
          //await getEmotionStampUseCase.getEmoticonStampByDefault();
        },
        error: (message) {},
      );
    }
  }
}
