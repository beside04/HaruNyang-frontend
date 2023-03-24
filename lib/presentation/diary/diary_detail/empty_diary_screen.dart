import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/presentation/components/back_icon.dart';
import 'package:frontend/presentation/components/bottom_button.dart';
import 'package:frontend/presentation/diary/diary_screen.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EmptyDiaryScreen extends StatelessWidget {
  final DateTime date;

  const EmptyDiaryScreen({
    Key? key,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          DateFormat('M월 d일').format(date),
          style: kHeader4Style.copyWith(
              color: Theme.of(context).colorScheme.textTitle),
        ),
        leading: BackIcon(
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: 121.h,
                ),
                Center(
                  child: Image.asset(
                    "lib/config/assets/images/character/box.png",
                    width: 280.w,
                    height: 280.h,
                  ),
                ),
                SizedBox(
                  height: 12.h,
                ),
                Text(
                  "작성한 일기가 없어요",
                  style: kHeader3Style.copyWith(
                      color: Theme.of(context).colorScheme.textTitle),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Text(
                  "일기를 쓰고 하루냥의 명언을 받아보세요!",
                  style: kBody2Style.copyWith(
                      color: Theme.of(context).colorScheme.textSubtitle),
                ),
              ],
            ),
          ),
          BottomButton(
            title: '일기쓰기',
            onTap: () {
              Get.to(
                () => DiaryScreen(
                  date: date,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
