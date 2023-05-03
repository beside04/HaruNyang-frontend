import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/domain/model/diary/diary_data.dart';
import 'package:frontend/global_controller/diary/diary_controller.dart';
import 'package:frontend/presentation/components/toast.dart';
import 'package:frontend/presentation/diary/diary_detail/diary_detail_screen.dart';
import 'package:frontend/presentation/diary/diary_detail/empty_diary_screen.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:get/get.dart';

DateFormat format = DateFormat('yyyy-MM-dd');

class EmotionCalendarWidget extends StatefulWidget {
  const EmotionCalendarWidget({super.key});

  @override
  State<EmotionCalendarWidget> createState() => _EmotionCalendarWidgetState();
}

class _EmotionCalendarWidgetState extends State<EmotionCalendarWidget> {
  final diaryController = Get.find<DiaryController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 20.h,
              left: 5.w,
              right: 5.w,
            ),
            child: Obx(
              () => TableCalendar<DiaryData>(
                onPageChanged: diaryController.onPageChanged,
                rowHeight: 70.h,
                focusedDay: diaryController.state.value.focusedCalendarDate,
                firstDay: DateTime(1900, 1),
                lastDay: DateTime(2199, 12),
                calendarFormat: CalendarFormat.month,
                weekendDays: const [DateTime.sunday, 6],
                startingDayOfWeek: StartingDayOfWeek.sunday,
                locale: 'ko-KR',
                daysOfWeekHeight: 30.h,
                headerVisible: false,
                eventLoader: (DateTime day) {
                  return diaryController.state.value.diaryDataList
                      .where(
                          (element) => element.writtenAt == format.format(day))
                      .toList();
                },
                calendarStyle: CalendarStyle(
                  cellPadding: EdgeInsets.only(top: 10.h),
                  cellAlignment: Alignment.bottomCenter,
                  isTodayHighlighted: true,
                  outsideDaysVisible: false,
                ),
                calendarBuilders: CalendarBuilders(
                  dowBuilder: (context, day) {
                    return Column(
                      children: [
                        Center(
                          child: Text(
                            DateFormat.E('ko-KR').format(day),
                            style: kHeader5Style.copyWith(
                                color: Theme.of(context).colorScheme.textTitle),
                          ),
                        ),
                      ],
                    );
                  },
                  markerBuilder: (context, day, events) {
                    return InkWell(
                      onTap: () {
                        diaryController.setSelectedCalendarDate(day);
                        diaryController.setFocusDay(day);

                        if ((DateTime.now().isAfter(day) || isToday(day))) {
                          events.isEmpty
                              ? Get.to(() => EmptyDiaryScreen(
                                    date: day,
                                  ))
                              : Get.to(
                                  () => DiaryDetailScreen(
                                    date: day,
                                    isStamp: true,
                                    diaryData: events[0],
                                  ),
                                );
                        } else {
                          toast(
                            context: context,
                            text: '미래 일기는 미리 쓸 수 없어요.',
                            isCheckIcon: false,
                          );
                        }
                      },
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.only(
                            top: 4.h,
                          ),
                          child: Column(
                            children: [
                              events.isEmpty && isToday(day)
                                  ? Container(
                                      padding: context.isTablet
                                          ? EdgeInsets.all(9.w)
                                          : EdgeInsets.all(16.w),
                                      decoration: BoxDecoration(
                                        border: isToday(day)
                                            ? Border.all(
                                                width: 1,
                                                color: kOrange300Color,
                                              )
                                            : null,
                                        shape: BoxShape.circle,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondaryColor,
                                      ),
                                    )
                                  : isToday(day)
                                      ? Stack(
                                          children: [
                                            Container(
                                              padding: context.isTablet
                                                  ? EdgeInsets.all(9.w)
                                                  : EdgeInsets.all(16.w),
                                              decoration: BoxDecoration(
                                                border: isToday(day)
                                                    ? Border.all(
                                                        width: 1,
                                                        color: kOrange300Color,
                                                      )
                                                    : null,
                                                shape: BoxShape.circle,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondaryColor,
                                              ),
                                            ),
                                            Positioned.fill(
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: SvgPicture.network(
                                                  events[0].emotion.emoticon,
                                                  width: 20.w,
                                                  height: 20.h,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : events.isNotEmpty
                                          ? Stack(
                                              children: [
                                                Container(
                                                  padding: context.isTablet
                                                      ? EdgeInsets.all(9.w)
                                                      : EdgeInsets.all(16.w),
                                                  decoration: BoxDecoration(
                                                    border: isToday(day)
                                                        ? Border.all(
                                                            width: 1,
                                                            color:
                                                                kOrange300Color,
                                                          )
                                                        : null,
                                                    shape: BoxShape.circle,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondaryColor,
                                                  ),
                                                ),
                                                Positioned.fill(
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: SvgPicture.network(
                                                      events[0]
                                                          .emotion
                                                          .emoticon,
                                                      width: 20.w,
                                                      height: 20.h,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : DateTime.now().isAfter(day)
                                              ? Container(
                                                  padding: context.isTablet
                                                      ? EdgeInsets.all(9.w)
                                                      : EdgeInsets.all(16.w),
                                                  decoration: BoxDecoration(
                                                    border: isToday(day)
                                                        ? Border.all(
                                                            width: 1,
                                                            color:
                                                                kOrange300Color,
                                                          )
                                                        : null,
                                                    shape: BoxShape.circle,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondaryColor,
                                                  ),
                                                )
                                              : Padding(
                                                  padding:
                                                      EdgeInsets.all(8.0.w),
                                                  child: Text(
                                                    DateFormat('d').format(day),
                                                    style: kBody1Style.copyWith(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .textSubtitle),
                                                  ),
                                                )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  prioritizedBuilder: (context, day, events) {
                    return isToday(day)
                        ? Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: Container(
                              width: 30.w,
                              height: 20.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: kOrange300Color,
                              ),
                              child: Center(
                                child: Text(
                                  DateFormat('d').format(day),
                                  style:
                                      kBody2Style.copyWith(color: kWhiteColor),
                                ),
                              ),
                            ),
                          )
                        : DateTime.now().isAfter(day)
                            ? Padding(
                                padding: EdgeInsets.all(8.0.w),
                                child: Text(
                                  DateFormat('d').format(day),
                                  style: kBody2Style.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .textTitle),
                                ),
                              )
                            : Container();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool isToday(DateTime date) {
    DateTime now = DateTime.now();
    if (format.format(now) == format.format(date)) {
      return true;
    }
    return false;
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    if (format.format(date1) == format.format(date2)) {
      return true;
    }
    return false;
  }
}
