import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/presentation/diary/diary_detail/diary_detail_screen.dart';
import 'package:frontend/presentation/emotion_stamp/components/emotion_card_diary_widget.dart';
import 'package:frontend/presentation/emotion_stamp/emotion_stamp_view_model.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

// ignore: must_be_immutable
class EmotionListWidget extends GetView<EmotionStampViewModel> {
  Map<String, bool> weekName = {};

  EmotionListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    weekName = {};
    String? swipeDirection;
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Listener(
        onPointerMove: (event) {
          swipeDirection = event.delta.dx < 0 ? 'right' : 'left';
        },
        onPointerUp: (event) {
          if (swipeDirection == null) {
            return;
          }
          if (swipeDirection == 'left') {
            controller.onPageChanged(Jiffy(controller.focusedCalendarDate.value)
                .subtract(months: 1)
                .dateTime);
          }
          if (swipeDirection == 'right') {
            controller.onPageChanged(Jiffy(controller.focusedCalendarDate.value)
                .add(months: 1)
                .dateTime);
          }
        },
        child: PageView.builder(
          controller: PageController(initialPage: controller.currentPageCount),
          itemBuilder: (context, i) {
            return ListView.builder(
              itemCount: controller.diaryDataList.isEmpty
                  ? 1
                  : controller.diaryDataList.length,
              itemBuilder: (BuildContext context, int index) {
                String dateTime = '';
                if (controller.diaryDataList.isNotEmpty) {
                  dateTime = weekOfMonthForSimple(DateTime.parse(
                      controller.diaryDataList[index].writtenAt));
                }

                return controller.diaryDataList.isEmpty
                    ? Column(
                        children: [
                          Column(
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
                                style: Theme.of(context).textTheme.headline5,
                              )
                            ],
                          ),
                        ],
                      )
                    : GestureDetector(
                        onTap: () {
                          Get.to(
                            () => DiaryDetailScreen(
                              date: DateTime.parse(
                                  controller.diaryDataList[index].writtenAt),
                              isStamp: true,
                              diaryData: controller.diaryDataList[index],
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
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: 20.h,
                                left: 20.w,
                                right: 20.w,
                              ),
                              child: EmotionCardDiaryWidget(
                                diaryData: controller.diaryDataList[index],
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
