import 'dart:async';
import 'package:frontend/domain/model/diary/diary_detail_data.dart';
import 'package:frontend/domain/use_case/diary/get_diary_detail_use_case.dart';
import 'package:frontend/domain/use_case/diary/save_diary_use_case.dart';
import 'package:frontend/domain/use_case/diary/update_diary_use_case.dart';
import 'package:frontend/presentation/diary/write_diary_success_screen.dart';
import 'package:get/get.dart';

class WriteDiaryLoadingViewModel extends GetxController {
  SaveDiaryUseCase saveDiaryUseCase;
  UpdateDiaryUseCase updateDiaryUseCase;

  WriteDiaryLoadingViewModel({
    required this.saveDiaryUseCase,
    required this.updateDiaryUseCase,
  });

  Future<void> saveDiaryDetail(diary, date) async {
    final result = await saveDiaryUseCase(diary);

    result.when(
      success: (data) {
        Get.to(
          () => WriteDiarySuccessScreen(
            date: date,
            diaryDetailData: data,
          ),
        );
      },
      error: (message) {},
    );
  }

  Future<void> updateDiaryDetail(diary, date) async {
    final result = await updateDiaryUseCase(diary);

    result.when(
      success: (data) {
        Get.to(
          () => WriteDiarySuccessScreen(
            date: date,
            diaryDetailData: data,
          ),
        );
      },
      error: (message) {},
    );
  }
}
