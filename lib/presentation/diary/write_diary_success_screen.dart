import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/domain/model/diary/diary_data.dart';
import 'package:frontend/domain/model/diary/diary_detail_data.dart';
import 'package:frontend/presentation/components/dialog_button.dart';
import 'package:frontend/presentation/diary/diary_detail/diary_comment_screen.dart';
import 'package:get/get.dart';

class WriteDiarySuccessScreen extends StatelessWidget {
  final DateTime date;
  final DiaryDetailData diaryDetailData;

  const WriteDiarySuccessScreen({
    Key? key,
    required this.date,
    required this.diaryDetailData,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "lib/config/assets/images/character/rain_character1.png",
            ),
            Column(
              children: [
                Text(
                  "님의 일기를 보고",
                  style: kHeader3Style.copyWith(
                    color: Theme.of(context).colorScheme.textTitle,
                  ),
                ),
                Text(
                  "하루냥의 한 마디를 준비했어요",
                  style: kHeader3Style.copyWith(
                    color: Theme.of(context).colorScheme.textTitle,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 52.h,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(
                    () => DiaryCommentScreen(
                        date: date, diaryDetailData: diaryDetailData),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kOrange200Color,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60),
                  ),
                ),
                child: Text(
                  "눌러보세요",
                  style: kHeader3Style.copyWith(
                    color: kBackGroundLightColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
