import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/presentation/emotion_stamp/emotion_stamp_detail_screen.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class Event {
  final String eventTitle;
  final String icon;

  Event({required this.eventTitle, required this.icon});

  @override
  String toString() => eventTitle;
}

class EmotionStampScreen extends StatefulWidget {
  const EmotionStampScreen({Key? key}) : super(key: key);

  @override
  State<EmotionStampScreen> createState() => _EmotionStampScreenState();
}

class _EmotionStampScreenState extends State<EmotionStampScreen> {
  var _focusedCalendarDate = DateTime.now();
  final _nowDate = DateTime.now();
  DateTime? selectedCalendarDate;

  late Map<DateTime, List<Event>> mySelectedEvents;

  @override
  void initState() {
    super.initState();
    selectedCalendarDate = _focusedCalendarDate;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Map<DateTime, dynamic> eventSource = {
    DateTime.utc(2022, 11, 20): [Event(eventTitle: 'test', icon: '😢')],
    DateTime.utc(2022, 11, 21): [Event(eventTitle: 'test1', icon: '😅')],
    DateTime.utc(2022, 11, 22): [Event(eventTitle: 'test2', icon: '🥲')],
    DateTime.utc(2022, 11, 26): [Event(eventTitle: 'test3', icon: '😍')],
    DateTime.utc(2022, 11, 28): [Event(eventTitle: 'test4', icon: '🥺')],
  };

  List<Event> _getEventsForDay(DateTime day) {
    return eventSource[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 20.h,
            ),
            TableCalendar<Event>(
              rowHeight: 70,
              focusedDay: _focusedCalendarDate,
              firstDay: DateTime(2000, 1),
              lastDay: DateTime(2099, 11),
              calendarFormat: CalendarFormat.month,
              weekendDays: const [DateTime.sunday, 6],
              startingDayOfWeek: StartingDayOfWeek.monday,
              locale: 'ko-KR',
              daysOfWeekHeight: 30,
              eventLoader: _getEventsForDay,
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
                      setState(() {
                        selectedCalendarDate = day;
                        _focusedCalendarDate = day;
                      });
                      Get.to(() => EmotionStampDetailScreen(
                            icon: events.isEmpty ? null : events[0].icon,
                            title: events.isEmpty ? null : events[0].eventTitle,
                          ));
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
                                      border: day.day == _nowDate.day &&
                                              day.month == _nowDate.month
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
                                          border: day.day == _nowDate.day &&
                                                  day.month == _nowDate.month
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
                  return day.day == selectedCalendarDate!.day &&
                          day.month == selectedCalendarDate!.month
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
                                style: kBody3WhiteStyle,
                              ),
                            ),
                          ),
                        )
                      : day.day == _nowDate.day && day.month == _nowDate.month
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                DateFormat('dd').format(day),
                                style: kBody3PrimaryStyle,
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                DateFormat('dd').format(day),
                                style: kBody3BlackStyle,
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
                            setState(() {
                              _focusedCalendarDate = date;
                            });
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
          ],
        ),
      ),
    );
  }
}
