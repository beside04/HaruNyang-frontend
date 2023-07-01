import 'dart:async';
import 'package:frontend/domain/use_case/diary/save_diary_use_case.dart';
import 'package:frontend/domain/use_case/diary/update_diary_use_case.dart';
import 'package:frontend/global_controller/diary/diary_controller.dart';
import 'package:frontend/presentation/diary/diary_detail/diary_detail_screen_test.dart';
import 'package:get/get.dart';

class WriteDiaryLoadingViewModel extends GetxController {
  SaveDiaryUseCase saveDiaryUseCase;
  UpdateDiaryUseCase updateDiaryUseCase;

  WriteDiaryLoadingViewModel({
    required this.saveDiaryUseCase,
    required this.updateDiaryUseCase,
  });

  final diaryController = Get.find<DiaryController>();

  Future<void> saveDiaryDetail(diary, date) async {
    final result = await saveDiaryUseCase(diary);

    result.when(
      success: (data) async {
        await diaryController.getDiaryDetail(data.id);

        Get.to(
          () => DiaryDetailScreenTest(
            diaryId: data.id,
            date: date,
            diaryData: diary,
            isNewDiary: true,
          ),
        );
      },
      error: (message) {},
    );
  }

  Future<void> updateDiaryDetail(diary, date) async {
    final result = await updateDiaryUseCase(diary);

    result.when(
      success: (data) async {
        await diaryController.getDiaryDetail(data.id);

        Get.to(
          () => DiaryDetailScreenTest(
            diaryId: data.id,
            date: date,
            diaryData: diary,
            isNewDiary: true,
          ),
        );
      },
      error: (message) {},
    );
  }
}
