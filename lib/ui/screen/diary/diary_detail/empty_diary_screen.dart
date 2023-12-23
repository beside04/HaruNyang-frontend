import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/core/utils/utils.dart';
import 'package:frontend/ui/components/back_icon.dart';
import 'package:frontend/ui/components/bottom_button.dart';
import 'package:frontend/ui/screen/diary/diary_screen.dart';
import 'package:intl/intl.dart';

class EmptyDiaryScreen extends StatelessWidget {
  final DateTime date;

  const EmptyDiaryScreen({
    Key? key,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      screenName: 'Screen_Event_EmptyDiary',
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            DateFormat('M월 d일').format(date),
            style: kHeader4Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
          ),
          leading: BackIcon(
            onPressed: () {
              Navigator.pop(context);
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
                      "lib/config/assets/images/character/haru_empty_case.png",
                      width: 280.w,
                      height: 280.h,
                    ),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Text(
                    "작성한 일기가 없어요",
                    style: kHeader3Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Text(
                    "일기를 쓰고 하루냥의 쪽지를 받아보세요!",
                    style: kBody2Style.copyWith(color: Theme.of(context).colorScheme.textSubtitle),
                  ),
                ],
              ),
            ),
            BottomButton(
              title: '일기쓰기',
              onTap: () {
                GlobalUtils.setAnalyticsCustomEvent('Click_EmptyDiary_WriteDiary');

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DiaryScreen(
                      date: date,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}