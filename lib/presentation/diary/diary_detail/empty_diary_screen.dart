import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/presentation/components/bottom_button.dart';
import 'package:frontend/presentation/diary/past_diary_screen.dart';
import 'package:frontend/presentation/diary/diary_view_model.dart';
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
        backgroundColor: kWhiteColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          DateFormat('MM월 dd일').format(date),
          style: kHeader3BlackStyle,
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: kBlackColor,
            size: 20.w,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 121.h,
                  ),
                  Center(
                    child: SvgPicture.asset(
                      "lib/config/assets/images/character/onboarding2.svg",
                      width: 240.w,
                      height: 240.h,
                    ),
                  ),
                  SizedBox(
                    height: 45.h,
                  ),
                  Text(
                    "작성한 일기가 없어요",
                    style: kSubtitle2BlackStyle,
                  )
                ],
              ),
            ),
            BottomButton(
              title: '일기쓰기',
              onTap: () {
                Get.delete<DiaryViewModel>();
                Get.to(() => PastDiaryTestScreen(
                      date: date,
                    ));
              },
            )
          ],
        ),
      ),
    );
  }
}
