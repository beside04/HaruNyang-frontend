import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/domain/model/diary/diary_detail_data.dart';
import 'package:frontend/domains/diary/provider/diary_provider.dart';
import 'package:frontend/res/constants.dart';
import 'package:frontend/ui/components/dialog_button.dart';
import 'package:frontend/ui/components/dialog_component.dart';
import 'package:frontend/ui/components/toast.dart';
import 'package:frontend/ui/screen/diary/diary_detail/diary_detail_screen.dart';
import 'package:frontend/ui/screen/diary/diary_detail/empty_diary_screen.dart';
import 'package:frontend/ui/screen/diary/write_diary_screen.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

DateFormat format = DateFormat('yyyy-MM-dd');

class EmotionCalendarWidget extends ConsumerStatefulWidget {
  const EmotionCalendarWidget({super.key});

  @override
  EmotionCalendarWidgetState createState() => EmotionCalendarWidgetState();
}

class EmotionCalendarWidgetState extends ConsumerState<EmotionCalendarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 20,
              left: 11,
              right: 11,
            ),
            child: Consumer(builder: (context, ref, child) {
              return TableCalendar<DiaryDetailData>(
                onPageChanged: ref.watch(diaryProvider.notifier).onPageChanged,
                rowHeight: 70,
                focusedDay: ref.watch(diaryProvider).focusedCalendarDate,
                firstDay: DateTime(1900, 1),
                lastDay: DateTime(2199, 12),
                calendarFormat: CalendarFormat.month,
                weekendDays: const [DateTime.sunday, 6],
                startingDayOfWeek: StartingDayOfWeek.sunday,
                locale: 'ko-KR',
                daysOfWeekHeight: 30,
                headerVisible: false,
                eventLoader: (DateTime day) {
                  return ref.watch(diaryProvider).diaryDataList.where((element) => element.targetDate == format.format(day)).toList();
                },
                calendarStyle: CalendarStyle(
                  cellPadding: EdgeInsets.only(top: 10),
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
                      onTap: () async {
                        ref.watch(diaryProvider.notifier).setSelectedCalendarDate(day);
                        ref.watch(diaryProvider.notifier).setFocusDay(day);

                        if ((DateTime.now().isAfter(day) || isToday(day))) {
                          if (events.isEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EmptyDiaryScreen(
                                  date: day,
                                ),
                              ),
                            );
                          } else if (events[0].isAutoSave) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WriteDiaryScreen(
                                        date: day,
                                        emotion: events[0].feeling,
                                        weather: events[0].weather,
                                        diaryData: events[0],
                                        isEditScreen: false,
                                        isAutoSave: true,
                                      )),
                            );
                          } else {
                            final saveDiary = await ref.watch(diaryProvider.notifier).getTempDiary(day);

                            if (saveDiary != null && mounted) {
                              Map<String, dynamic> diaryMap = json.decode(saveDiary);
                              DiaryDetailData saveDiaryData = DiaryDetailData.fromJson(diaryMap);

                              showDialog(
                                barrierDismissible: true,
                                context: context,
                                builder: (context) {
                                  return DialogComponent(
                                    title: "임시 저장된 글이 있어요",
                                    content: Text(
                                      "임시 저장된 글을 불러 올까요?",
                                      style: kHeader6Style.copyWith(color: Theme.of(context).colorScheme.textSubtitle),
                                    ),
                                    actionContent: [
                                      DialogButton(
                                        title: "아니요",
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => DiaryDetailScreen(
                                                diaryId: events[0].id!,
                                                date: day,
                                                isNewDiary: false,
                                                isFromBookmarkPage: false,
                                              ),
                                            ),
                                          );
                                        },
                                        backgroundColor: Theme.of(context).colorScheme.secondaryColor,
                                        textStyle: kHeader4Style.copyWith(color: Theme.of(context).colorScheme.textSubtitle),
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      DialogButton(
                                        title: "예",
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => WriteDiaryScreen(
                                                      date: DateTime.parse(saveDiaryData.targetDate),
                                                      emotion: saveDiaryData.feeling,
                                                      weather: saveDiaryData.weather,
                                                      diaryData: saveDiaryData,
                                                      isEditScreen: true,
                                                      isAutoSave: true,
                                                    )),
                                          );
                                        },
                                        backgroundColor: kOrange200Color,
                                        textStyle: kHeader4Style.copyWith(color: kWhiteColor),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DiaryDetailScreen(
                                    diaryId: events[0].id!,
                                    date: day,
                                    // diaryData: events[0],
                                    isNewDiary: false,
                                    isFromBookmarkPage: false,
                                  ),
                                ),
                              );
                            }
                          }
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
                            top: 4,
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
                                          events[0].isAutoSave
                                              ? Theme.of(context).colorScheme.brightness == Brightness.dark
                                                  ? "lib/config/assets/images/diary/emotion/save-dark.png"
                                                  : "lib/config/assets/images/diary/emotion/save-light.png"
                                              : getEmoticonImage(events[0].feeling),
                                          width: 36,
                                        )
                                      : events.isNotEmpty
                                          ? Align(
                                              alignment: Alignment.center,
                                              child: Image.asset(
                                                events[0].isAutoSave
                                                    ? Theme.of(context).colorScheme.brightness == Brightness.dark
                                                        ? "lib/config/assets/images/diary/emotion/save-dark.png"
                                                        : "lib/config/assets/images/diary/emotion/save-light.png"
                                                    : getEmoticonImage(events[0].feeling),
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
                                                  padding: EdgeInsets.all(8.0),
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
                              width: 25,
                              height: 16,
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
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  DateFormat('d').format(day),
                                  style: kCaption1Style.copyWith(color: Theme.of(context).colorScheme.iconSubColor),
                                ),
                              )
                            : Container();
                  },
                ),
              );
            }),
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
