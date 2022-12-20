import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/domain/model/Emoticon/emoticon_data.dart';
import 'package:frontend/presentation/diary/diary_detail/diary_detail_screen.dart';
import 'package:frontend/presentation/diary/diary_detail/empty_diary_screen.dart';
import 'package:frontend/presentation/emotion_stamp/emotion_stamp_view_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:table_calendar/table_calendar.dart';

class EmotionStampScreen extends GetView<EmotionStampViewModel> {
  const EmotionStampScreen({super.key});

  @override
  Widget build(BuildContext context) {
    getEmotionStampBinding();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        elevation: 0,
        centerTitle: true,
        actions: [
          Obx(
            () => IconButton(
              onPressed: () {
                controller.isCalendar.value = !controller.isCalendar.value;
              },
              icon: controller.isCalendar.value
                  ? const Icon(Icons.list)
                  : const Icon(Icons.calendar_month_outlined),
              color: kBlackColor,
            ),
          )
        ],
        title: Obx(
          () => InkWell(
            onTap: () {
              DatePicker.showPicker(
                context,
                pickerModel: YearMonthModel(
                  currentTime: controller.focusedCalendarDate.value,
                  maxTime: DateTime(2099, 12),
                  minTime: DateTime(2000, 1),
                  locale: LocaleType.ko,
                ),
                showTitleActions: true,
                onConfirm: (date) {
                  controller.focusedCalendarDate.value = date;
                },
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
                    DateFormat('yyyy년 MM월')
                        .format(controller.focusedCalendarDate.value),
                    style: kHeader3BlackStyle,
                  ),
                  SizedBox(
                    width: 6.w,
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: kBlackColor,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 20.h,
            ),
            Obx(
              () => Expanded(
                child: PageTransitionSwitcher(
                  duration: const Duration(milliseconds: 300),
                  reverse: !controller.isCalendar.value,
                  transitionBuilder: (Widget child, Animation<double> animation,
                      Animation<double> secondaryAnimation) {
                    return SharedAxisTransition(
                      animation: animation,
                      secondaryAnimation: secondaryAnimation,
                      transitionType: SharedAxisTransitionType.horizontal,
                      child: child,
                    );
                  },
                  child: controller.isCalendar.value
                      ? Obx(
                          () => TableCalendar<TempEvent>(
                            onPageChanged: (day) {
                              controller.focusedCalendarDate.value = day;
                            },
                            rowHeight: 70,
                            focusedDay: controller.focusedCalendarDate.value,
                            firstDay: DateTime(1900, 1),
                            lastDay: DateTime(2199, 12),
                            calendarFormat: CalendarFormat.month,
                            weekendDays: const [DateTime.sunday, 6],
                            startingDayOfWeek: StartingDayOfWeek.monday,
                            locale: 'ko-KR',
                            daysOfWeekHeight: 30,
                            headerVisible: false,
                            eventLoader: (DateTime day) {
                              return controller.tempEventSource[day] ?? [];
                            },
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

                                    events.isEmpty
                                        ? Get.to(() => EmptyDiaryScreen(
                                              date: day,
                                            ))
                                        : Get.to(
                                            () => DiaryDetailScreen(
                                              date: day,
                                              emoticon: EmoticonData(
                                                id: 3,
                                                emoticon:
                                                    'https://firebasestorage.googleapis.com/v0/b/dark-room-84532.appspot.com/o/happy.svg?alt=media',
                                                value: '기쁨',
                                                desc: '기쁨',
                                              ),
                                              diaryContent: '',
                                              emoticonIndex: 3,
                                              weather: '',
                                            ),
                                          );
                                  },
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                        top: 10,
                                      ),
                                      child: Column(
                                        children: [
                                          events.isEmpty
                                              ? Container(
                                                  padding: EdgeInsets.all(14.w),
                                                  decoration: BoxDecoration(
                                                    border:
                                                        controller.isToday(day)
                                                            ? Border.all(
                                                                width: 1,
                                                                color:
                                                                    kPrimaryColor,
                                                              )
                                                            : null,
                                                    shape: BoxShape.circle,
                                                    color: kGrayColor100,
                                                  ),
                                                )
                                              : Stack(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(14.w),
                                                      decoration: BoxDecoration(
                                                        border: controller
                                                                .isToday(day)
                                                            ? Border.all(
                                                                width: 1,
                                                                color:
                                                                    kPrimaryColor,
                                                              )
                                                            : null,
                                                        shape: BoxShape.circle,
                                                        color: kGrayColor100,
                                                      ),
                                                    ),
                                                    Positioned.fill(
                                                      child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child:
                                                            SvgPicture.network(
                                                          events[0].icon,
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
                                return controller.isDateClicked(day)
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
                                              style: kCaption1WhiteStyle,
                                            ),
                                          ),
                                        ),
                                      )
                                    : controller.isToday(day)
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              DateFormat('dd').format(day),
                                              style: kCaption1PrimaryStyle,
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              DateFormat('dd').format(day),
                                              style: kCaption1BlackStyle,
                                            ),
                                          );
                              },
                            ),
                          ),
                        )
                      : PageView.builder(
                          controller: PageController(
                              initialPage: controller.currentPageCount.value),
                          onPageChanged: (currentPage) {
                            // controllerTempCount와 비교해서 currentPage와 비교해서
                            // currentPage가 더 크면 1달 추가 그게 아니라면
                            // 1달 감소

                            if (controller.controllerTempCount.value <
                                currentPage) {
                              controller.focusedCalendarDate.value =
                                  Jiffy(controller.focusedCalendarDate.value)
                                      .add(months: 1)
                                      .dateTime;

                              controller.focusedStartDate.value = DateTime(
                                controller.focusedCalendarDate.value.year,
                                controller.focusedCalendarDate.value.month,
                                1,
                              );

                              controller.focusedEndDate.value = DateTime(
                                controller.focusedCalendarDate.value.year,
                                controller.focusedCalendarDate.value.month + 1,
                                0,
                              );
                              controller.getEmotionStampList();
                            } else {
                              controller.focusedCalendarDate.value =
                                  Jiffy(controller.focusedCalendarDate.value)
                                      .subtract(months: 1)
                                      .dateTime;

                              controller.focusedStartDate.value = DateTime(
                                controller.focusedCalendarDate.value.year,
                                controller.focusedCalendarDate.value.month,
                                1,
                              );

                              controller.focusedEndDate.value = DateTime(
                                controller.focusedCalendarDate.value.year,
                                controller.focusedCalendarDate.value.month + 1,
                                0,
                              );

                              controller.getEmotionStampList();
                            }

                            controller.controllerTempCount.value = currentPage;
                          },
                          itemBuilder: (context, i) {
                            return Obx(
                              () {
                                if (controller.isLoading.value) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else {
                                  return ListView.builder(
                                    itemCount: (controller
                                                    .dataResult["key_ordered"]
                                                as List)
                                            .isEmpty
                                        ? 1
                                        : (controller.dataResult["key_ordered"]
                                                as List)
                                            .length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return (controller
                                                      .dataResult["key_ordered"]
                                                  as List)
                                              .isEmpty
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
                                                      style:
                                                          kSubtitle2BlackStyle,
                                                    )
                                                  ],
                                                ),
                                              ],
                                            )
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 20.h, left: 20.w),
                                                  child: Text(
                                                    "${(controller.dataResult["key_ordered"] as List)[index]}번째 주",
                                                    style: kSubtitle1BlackStyle,
                                                  ),
                                                ),
                                                ListView.builder(
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount: (controller
                                                                  .dataResult[
                                                              "values"]
                                                          as Map)[(controller
                                                                  .dataResult[
                                                              "key_ordered"]
                                                          as List)[index]]
                                                      .length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int i) {
                                                    var itemList = (controller
                                                                .dataResult[
                                                            "values"] as Map)[
                                                        (controller.dataResult[
                                                                "key_ordered"]
                                                            as List)[index]][i];
                                                    return Padding(
                                                      padding: EdgeInsets.only(
                                                        top: 20.h,
                                                        left: 20.w,
                                                        right: 20.w,
                                                      ),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: kGrayColor50,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.0.w),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              kPrimaryPadding,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    DateFormat.MMMEd(
                                                                            "ko_KR")
                                                                        .format(
                                                                            DateTime.parse(itemList.createdAt)),
                                                                    style:
                                                                        kSubtitle2BlackStyle,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                        padding:
                                                                            EdgeInsets.all(4.w),
                                                                        decoration:
                                                                            const BoxDecoration(
                                                                          shape:
                                                                              BoxShape.circle,
                                                                          color:
                                                                              kWhiteColor,
                                                                        ),
                                                                        child: SvgPicture
                                                                            .asset(
                                                                          "lib/config/assets/images/diary/weather/sunny.svg",
                                                                          width:
                                                                              16.w,
                                                                          height:
                                                                              16.h,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            7.w,
                                                                      ),
                                                                      Container(
                                                                        padding:
                                                                            EdgeInsets.all(4.w),
                                                                        decoration:
                                                                            const BoxDecoration(
                                                                          shape:
                                                                              BoxShape.circle,
                                                                          color:
                                                                              kWhiteColor,
                                                                        ),
                                                                        child: SvgPicture
                                                                            .network(
                                                                          itemList
                                                                              .emotion
                                                                              .emoticon,
                                                                          width:
                                                                              16.w,
                                                                          height:
                                                                              16.h,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 12.h,
                                                              ),
                                                              itemList.images[
                                                                          0] ==
                                                                      ""
                                                                  ? Container()
                                                                  : Column(
                                                                      children: [
                                                                        Center(
                                                                          child:
                                                                              Image.network(
                                                                            "${itemList.images[0]}",
                                                                            height:
                                                                                240.h,
                                                                            width:
                                                                                double.infinity,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              12.h,
                                                                        ),
                                                                      ],
                                                                    ),
                                                              Text(
                                                                itemList
                                                                    .content,
                                                                style:
                                                                    kBody1BlackStyle,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            );
                                    },
                                  );
                                }
                              },
                            );
                          },
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class YearMonthModel extends DatePickerModel {
  YearMonthModel(
      {required DateTime currentTime,
      required DateTime maxTime,
      required DateTime minTime,
      required LocaleType locale})
      : super(
            currentTime: currentTime,
            maxTime: maxTime,
            minTime: minTime,
            locale: locale);

  @override
  List<int> layoutProportions() {
    return [1, 1, 0];
  }
}
