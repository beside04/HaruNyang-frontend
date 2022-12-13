import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/presentation/diary/diary_detail/diary_detail_screen.dart';
import 'package:frontend/presentation/emotion_stamp/emotion_stamp_view_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class EmotionStampScreen extends GetView<EmotionStampViewModel> {
  const EmotionStampScreen({super.key});

  @override
  Widget build(BuildContext context) {
    getEmotionStampBinding();

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 20.h,
            ),
            Obx(
              () => TableCalendar<TempEvent>(
                rowHeight: 70,
                focusedDay: controller.focusedCalendarDate.value,
                firstDay: DateTime(2000, 1),
                lastDay: DateTime(2099, 11),
                calendarFormat: CalendarFormat.month,
                weekendDays: const [DateTime.sunday, 6],
                startingDayOfWeek: StartingDayOfWeek.monday,
                locale: 'ko-KR',
                daysOfWeekHeight: 30,
                eventLoader: (DateTime day) {
                  return controller.tempEventSource[day] ?? [];
                },
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  leftChevronVisible: false,
                  rightChevronVisible: false,
                ),
                calendarStyle: const CalendarStyle(
                  cellPadding: EdgeInsets.only(top: 5),
                  cellAlignment: Alignment.bottomCenter,
                  isTodayHighlighted: true,
                  outsideDaysVisible: false,
                ),
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, day, events) {
                    return InkWell(
                      onTap: () {
                        controller.selectedCalendarDate.value = day;
                        controller.focusedCalendarDate.value = day;

                        // events.isEmpty ? null

                        Get.to(
                          () => DiaryDetailScreen(
                            date: day,
                          ),
                        );
                      },
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.only(
                            top: 10,
                            left: 2,
                          ),
                          child: Column(
                            children: [
                              events.isEmpty
                                  ? Container(
                                      padding: const EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        border: controller.isToday(day)
                                            ? Border.all(
                                                width: 1,
                                                color: kPrimaryColor,
                                              )
                                            : null,
                                        shape: BoxShape.circle,
                                        color: kGrayColor100,
                                      ),
                                    )
                                  : Stack(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                            border: controller.isToday(day)
                                                ? Border.all(
                                                    width: 1,
                                                    color: kPrimaryColor,
                                                  )
                                                : null,
                                            shape: BoxShape.circle,
                                            color: kGrayColor100,
                                          ),
                                        ),
                                        Positioned.fill(
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              events[0].icon,
                                              style: const TextStyle(
                                                fontSize: 20,
                                              ),
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
                    return controller.isDateClicked(day)
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 26.w,
                              height: 14.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: kPrimaryColor,
                              ),
                              child: Center(
                                child: Text(
                                  DateFormat('dd').format(day),
                                  style: kBody2WhiteStyle,
                                ),
                              ),
                            ),
                          )
                        : controller.isToday(day)
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  DateFormat('dd').format(day),
                                  style: kBody2PrimaryStyle,
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  DateFormat('dd').format(day),
                                  style: kBody2BlackStyle,
                                ),
                              );
                  },
                  headerTitleBuilder: (context, day) {
                    return Center(
                      child: InkWell(
                        onTap: () {
                          DatePicker.showDatePicker(
                            context,
                            showTitleActions: true,
                            minTime: DateTime(2000, 1),
                            maxTime: DateTime(2099, 11),
                            onConfirm: (date) {
                              controller.focusedCalendarDate.value = date;
                            },
                            currentTime: DateTime.now(),
                            locale: LocaleType.ko,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                DateFormat('yyyy년 MM월').format(day),
                                style: kHeader3BlackStyle,
                              ),
                              SizedBox(
                                width: 6.w,
                              ),
                              const Icon(Icons.keyboard_arrow_down)
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
