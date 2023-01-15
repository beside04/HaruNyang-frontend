import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
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
          DateFormat('MM월 dd일').format(date),
          style: kHeader3Style.copyWith(
              color: Theme.of(context).colorScheme.textTitle),
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
                    style: kHeader5Style.copyWith(
                        color: Theme.of(context).colorScheme.textTitle),
                  )
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
            )
          ],
        ),
      ),
    );
  }
}
