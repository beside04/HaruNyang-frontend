import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/domain/use_case/diary/save_diary_use_case.dart';
import 'package:frontend/domain/use_case/diary/update_diary_use_case.dart';
import 'package:frontend/global_controller/diary/diary_controller.dart';
import 'package:frontend/main.dart';
import 'package:frontend/presentation/components/dialog_button.dart';
import 'package:frontend/presentation/components/dialog_component.dart';
import 'package:frontend/presentation/diary/diary_detail/diary_detail_screen.dart';
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
          () => DiaryDetailScreen(
            diaryId: data.id,
            date: date,
            diaryData: diary,
            isNewDiary: true,
          ),
        );
      },
      error: (message) {
        showDialog(
          barrierDismissible: true,
          context: navigatorKey.currentContext!,
          builder: (context) {
            return DialogComponent(
              titlePadding: EdgeInsets.zero,
              title: "",
              content: Column(
                children: [
                  Image.asset(
                    "lib/config/assets/images/character/update1.png",
                    width: 120.w,
                    height: 120.h,
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Text(
                    "하루냥이 잠깐 낮잠을 자고 있어요.",
                    style: kHeader3Style.copyWith(
                        color: Theme.of(context).colorScheme.textTitle),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Text(
                    "대신 재밌는 명언을 추천해드릴게요.",
                    style: kHeader6Style.copyWith(
                        color: Theme.of(context).colorScheme.textSubtitle),
                  ),
                ],
              ),
              actionContent: [
                DialogButton(
                  title: "알겠어요",
                  onTap: () async {
                    Get.back();
                  },
                  backgroundColor: kOrange200Color,
                  textStyle: kHeader4Style.copyWith(color: kWhiteColor),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> updateDiaryDetail(diary, date) async {
    final result = await updateDiaryUseCase(diary);

    result.when(
      success: (data) async {
        await diaryController.getDiaryDetail(data.id);

        Get.to(
          () => DiaryDetailScreen(
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
