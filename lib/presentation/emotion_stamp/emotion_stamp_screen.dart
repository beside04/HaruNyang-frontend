import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/presentation/emotion_stamp/components/emotion_calendar_widget.dart';
import 'package:frontend/presentation/emotion_stamp/components/emotion_list_widget.dart';
import 'package:frontend/presentation/emotion_stamp/emotion_stamp_view_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EmotionStampScreen extends StatefulWidget {
  const EmotionStampScreen({super.key});

  @override
  State<EmotionStampScreen> createState() => _EmotionStampScreenState();
}

class _EmotionStampScreenState extends State<EmotionStampScreen> {
  late final EmotionStampViewModel controller;

  @override
  void initState() {
    Get.delete<EmotionStampViewModel>();
    controller = getEmotionStampBinding();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  controller.getMonthStartEndData();
                  controller.getEmotionStampList();
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
                  child: controller.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : controller.isCalendar.value
                          ? Obx(
                              () {
                                return EmotionCalendarWidget(
                                  onPageChanged: controller.onPageChanged,
                                  focusedDate:
                                      controller.focusedCalendarDate.value,
                                  diaryCalendarDataList:
                                      controller.diaryCalendarDataList,
                                  onSetFocusDay: controller.setFocusDay,
                                );
                              },
                            )
                          : Obx(
                              () {
                                return EmotionListWidget(
                                  focusedDate:
                                      controller.focusedCalendarDate.value,
                                  onSetFocusDay: controller.setFocusDay,
                                  diaryListDataList:
                                      controller.diaryListDataList,
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
