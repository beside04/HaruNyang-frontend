import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/domain/model/diary/diary_data.dart';
import 'package:frontend/global_controller/diary/diary_controller.dart';
import 'package:frontend/presentation/components/toast.dart';
import 'package:frontend/presentation/diary/diary_detail/diary_detail_screen.dart';
import 'package:frontend/presentation/diary/diary_detail/empty_diary_screen.dart';
import 'package:frontend/res/constants.dart';
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
              left: 11,
              right: 11,
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
                  return diaryController.state.value.diaryDataList.where((element) => element.targetDate == format.format(day)).toList();
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
                            style: kSubtitle1Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
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
                                    diaryId: events[0].id!,
                                    date: day,
                                    diaryData: events[0],
                                    isNewDiary: false,
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
                                  ? Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Image.asset(
                                        Theme.of(context).colorScheme.brightness == Brightness.dark
                                            ? "lib/config/assets/images/diary/dark_mode/empty_container.png"
                                            : "lib/config/assets/images/diary/light_mode/empty_container.png",
                                        width: 30,
                                      ),
                                    )
                                  : isToday(day)
                                      ? Image.asset(
                                          getEmoticonImage(events[0].feeling),
                                          width: 36,
                                        )
                                      : events.isNotEmpty
                                          ? Align(
                                              alignment: Alignment.center,
                                              child: Image.asset(
                                                getEmoticonImage(events[0].feeling),
                                                width: 36,
                                              ),
                                            )
                                          : DateTime.now().isAfter(day)
                                              ?
                                              // Container(
                                              //                     padding: context.isTablet ? EdgeInsets.all(9.w) : EdgeInsets.all(16.w),
                                              //                     decoration: BoxDecoration(
                                              //                       border: isToday(day)
                                              //                           ? Border.all(
                                              //                               width: 1,
                                              //                               color: kOrange300Color,
                                              //                             )
                                              //                           : null,
                                              //                       shape: BoxShape.circle,
                                              //                       color: Theme.of(context).colorScheme.surface_01,
                                              //                     ),
                                              //                   )

                                              Padding(
                                                  padding: EdgeInsets.only(top: 5),
                                                  child: Image.asset(
                                                    Theme.of(context).colorScheme.brightness == Brightness.dark
                                                        ? "lib/config/assets/images/diary/dark_mode/empty_container.png"
                                                        : "lib/config/assets/images/diary/light_mode/empty_container.png",
                                                    width: 30,
                                                  ),
                                                )
                                              : Padding(
                                                  padding: EdgeInsets.all(8.0.w),
                                                  child: Text(
                                                    DateFormat('d').format(day),
                                                    style: kHeader6Style.copyWith(color: Theme.of(context).colorScheme.iconSubColor),
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
                            padding: const EdgeInsets.only(
                              bottom: 14,
                            ),
                            child: Container(
                              width: 25.w,
                              height: 16.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: kOrange300Color,
                              ),
                              child: Center(
                                child: Text(
                                  DateFormat('d').format(day),
                                  style: kCaption1Style.copyWith(color: kWhiteColor),
                                ),
                              ),
                            ),
                          )
                        : DateTime.now().isAfter(day)
                            ? Padding(
                                padding: EdgeInsets.all(16.0.w),
                                child: Text(
                                  DateFormat('d').format(day),
                                  style: kCaption1Style.copyWith(color: Theme.of(context).colorScheme.iconSubColor),
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
