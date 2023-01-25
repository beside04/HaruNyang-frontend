import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/global_controller/diary/diary_controller.dart';
import 'package:frontend/presentation/diary/diary_detail/diary_detail_screen.dart';
import 'package:frontend/presentation/emotion_stamp/components/emotion_card_diary_widget.dart';
import 'package:frontend/presentation/emotion_stamp/components/swipe_detector.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

class EmotionListWidget extends StatefulWidget {
  const EmotionListWidget({super.key});

  @override
  State<EmotionListWidget> createState() => _EmotionListWidgetState();
}

class _EmotionListWidgetState extends State<EmotionListWidget> {
  Map<String, bool> weekName = {};
  final diaryController = Get.find<DiaryController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SwipeDetector(
        onSwipeLeft: () {
          diaryController.onPageChanged(
              Jiffy(diaryController.state.value.focusedCalendarDate)
                  .add(months: 1)
                  .dateTime);
        },
        onSwipeRight: () {
          diaryController.onPageChanged(
              Jiffy(diaryController.state.value.focusedCalendarDate)
                  .subtract(months: 1)
                  .dateTime);
        },
        child: PageView.builder(
          physics: const NeverScrollableScrollPhysics(),
          controller:
              PageController(initialPage: diaryController.currentPageCount),
          itemBuilder: (context, i) {
            return ListView.builder(
              itemCount: diaryController.state.value.diaryDataList.isEmpty
                  ? 1
                  : diaryController.state.value.diaryDataList.length,
              itemBuilder: (BuildContext context, int index) {
                String dateTime = '';
                if (diaryController.state.value.diaryDataList.isNotEmpty) {
                  dateTime = weekOfMonthForSimple(DateTime.parse(diaryController
                      .state.value.diaryDataList[index].writtenAt));
                }

                return diaryController.state.value.diaryDataList.isEmpty
                    ? Column(
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: 121.h,
                              ),
                              Center(
                                child: SvgPicture.asset(
                                  "lib/config/assets/images/character/character6.svg",
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
                                    color: Theme.of(context)
                                        .colorScheme
                                        .textTitle),
                              )
                            ],
                          ),
                        ],
                      )
                    : GestureDetector(
                        onTap: () {
                          Get.to(
                            () => DiaryDetailScreen(
                              date: DateTime.parse(diaryController
                                  .state.value.diaryDataList[index].writtenAt),
                              isStamp: true,
                              diaryData: diaryController
                                  .state.value.diaryDataList[index],
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!isUsedWeekName(dateTime))
                              Padding(
                                padding: EdgeInsets.only(top: 20.h, left: 20.w),
                                child: Text(
                                  "$dateTime번째 주",
                                  style: kHeader3Style.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .textTitle),
                                ),
                              ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: 20.h,
                                left: 20.w,
                                right: 20.w,
                              ),
                              child: EmotionCardDiaryWidget(
                                diaryData: diaryController
                                    .state.value.diaryDataList[index],
                              ),
                            )
                          ],
                        ),
                      );
              },
            );
          },
        ),
      ),
    );
  }

  // 월 주차. (단순하게 1일이 1주차 시작).
  String weekOfMonthForSimple(DateTime date) {
    // 월의 첫번째 날짜.
    DateTime firstDay = DateTime(date.year, date.month, 1);

    // 월중에 첫번째 월요일인 날짜.
    DateTime firstMonday = firstDay
        .add(Duration(days: (DateTime.monday + 7 - firstDay.weekday) % 7));

    // 첫번째 날짜와 첫번째 월요일인 날짜가 동일한지 판단.
    // 동일할 경우: 1, 동일하지 않은 경우: 2 를 마지막에 더한다.
    final bool isFirstDayMonday = firstDay == firstMonday;

    final different = calculateDaysBetween(from: firstMonday, to: date);

    // 주차 계산.
    int weekOfMonth = (different / 7 + (isFirstDayMonday ? 1 : 2)).toInt();

    switch (weekOfMonth) {
      case 1:
        return "첫";
      case 2:
        return "두";
      case 3:
        return "세";
      case 4:
        return "네";
      case 5:
        return "다섯";
    }
    return "";
  }

  bool isUsedWeekName(String week) {
    if (!weekName.containsKey(week)) {
      weekName[week] = true;
    } else if (weekName[week] == true) {
      return true;
    }
    return false;
  }

  // D-Day 계산.
  int calculateDaysBetween({required DateTime from, required DateTime to}) {
    return (to.difference(from).inHours / 24).round();
  }
}
