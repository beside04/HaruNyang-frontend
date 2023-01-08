import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/domain/model/diary/diary_data.dart';
import 'package:frontend/presentation/components/dialog_button.dart';
import 'package:frontend/presentation/components/dialog_component.dart';
import 'package:frontend/presentation/diary/diary_detail/diary_detail_screen.dart';
import 'package:frontend/presentation/diary/diary_detail/empty_diary_screen.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:get/get.dart';

DateFormat format = DateFormat('yyyy-MM-dd');

class EmotionCalendarWidget extends StatefulWidget {
  const EmotionCalendarWidget({
    Key? key,
    required this.onPageChanged,
    required this.focusedDate,
    required this.onSetFocusDay,
    required this.diaryDataList,
  }) : super(key: key);

  final DateTime focusedDate;
  final Function(DateTime) onPageChanged;
  final Function(DateTime) onSetFocusDay;
  final List<DiaryData> diaryDataList;

  @override
  State<EmotionCalendarWidget> createState() => _EmotionCalendarWidgetState();
}

class _EmotionCalendarWidgetState extends State<EmotionCalendarWidget> {
  DateTime selectedCalendarDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: TableCalendar<DiaryData>(
        onPageChanged: widget.onPageChanged,
        rowHeight: 70.h,
        focusedDay: widget.focusedDate,
        firstDay: DateTime(1900, 1),
        lastDay: DateTime(2199, 12),
        calendarFormat: CalendarFormat.month,
        weekendDays: const [DateTime.sunday, 6],
        startingDayOfWeek: StartingDayOfWeek.monday,
        locale: 'ko-KR',
        daysOfWeekHeight: 30.h,
        headerVisible: false,
        eventLoader: (DateTime day) {
          return widget.diaryDataList
              .where((element) => element.writtenAt == format.format(day))
              .toList();
        },
        calendarStyle: CalendarStyle(
          cellPadding: EdgeInsets.only(top: 5.h),
          cellAlignment: Alignment.bottomCenter,
          isTodayHighlighted: true,
          outsideDaysVisible: false,
        ),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, day, events) {
            return InkWell(
              onTap: () {
                selectedCalendarDate = day;
                widget.onSetFocusDay(day);

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
                  showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (ctx) {
                      return DialogComponent(
                        title: "미래 일기는 쓸 수 없어요",
                        actionContent: [
                          DialogButton(
                              title: "확인",
                              onTap: () {
                                Get.back();
                              },
                              backgroundColor: Theme.of(context).primaryColor,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(color: kWhiteColor)),
                        ],
                      );
                    },
                  );
                }
              },
              child: Center(
                child: Container(
                  padding: EdgeInsets.only(
                    top: 10.h,
                  ),
                  child: Column(
                    children: [
                      events.isEmpty
                          ? Container(
                              padding: context.isTablet
                                  ? EdgeInsets.all(9.w)
                                  : EdgeInsets.all(14.w),
                              decoration: BoxDecoration(
                                border: isToday(day)
                                    ? Border.all(
                                        width: 1,
                                        color: kPrimaryColor,
                                      )
                                    : null,
                                shape: BoxShape.circle,
                                color: Theme.of(context)
                                    .colorScheme
                                    .darkTheme_50_850,
                              ),
                            )
                          : Stack(
                              children: [
                                Container(
                                  padding: context.isTablet
                                      ? EdgeInsets.all(9.w)
                                      : EdgeInsets.all(14.w),
                                  decoration: BoxDecoration(
                                    border: isToday(day)
                                        ? Border.all(
                                            width: 1,
                                            color: kPrimaryColor,
                                          )
                                        : null,
                                    shape: BoxShape.circle,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .darkTheme_50_850,
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
                            ),
                    ],
                  ),
                ),
              ),
            );
          },
          prioritizedBuilder: (context, day, events) {
            return isSameDate(selectedCalendarDate, day)
                ? Padding(
                    padding: EdgeInsets.only(
                      bottom: 5.0.h,
                    ),
                    child: Container(
                      width: 20.w,
                      height: 20.h,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: kPrimaryColor,
                      ),
                      child: Center(
                        child: Text(
                          DateFormat('dd').format(day),
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(color: kWhiteColor),
                        ),
                      ),
                    ),
                  )
                : isToday(day)
                    ? Padding(
                        padding: EdgeInsets.all(8.0.w),
                        child: Text(
                          DateFormat('dd').format(day),
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(color: kPrimaryColor),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.all(8.0.w),
                        child: Text(
                          DateFormat('dd').format(day),
                          style: Theme.of(context).textTheme.caption,
                        ),
                      );
          },
        ),
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
