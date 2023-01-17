import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/core/utils/library/date_time_spinner/BasePickerModel.dart';
import 'package:frontend/core/utils/library/date_time_spinner/DatePickerTheme.dart';
import 'package:frontend/core/utils/library/date_time_spinner/date_time_spinner.dart';
import 'package:frontend/core/utils/library/date_time_spinner/i18n_model.dart';
import 'package:frontend/presentation/emotion_stamp/components/emotion_calendar_widget.dart';
import 'package:frontend/presentation/emotion_stamp/components/emotion_list_widget.dart';
import 'package:frontend/presentation/emotion_stamp/emotion_stamp_view_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EmotionStampScreen extends GetView<EmotionStampViewModel> {
  const EmotionStampScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          Obx(
            () => IconButton(
              onPressed: () {
                controller.isCalendar.value = !controller.isCalendar.value;
              },
              icon: controller.isCalendar.value
                  ? const Icon(Icons.list)
                  : const Icon(Icons.calendar_month_outlined),
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
                theme: DatePickerTheme(
                  itemStyle: kSubtitle1Style.copyWith(
                      color: Theme.of(context).colorScheme.textBody),
                  backgroundColor:
                      Theme.of(context).colorScheme.backgroundModal,
                  title: "다른 날짜 일기 보기",
                ),
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
                    style: kHeader3Style.copyWith(
                        color: Theme.of(context).colorScheme.textTitle),
                  ),
                  SizedBox(
                    width: 6.w,
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Theme.of(context).colorScheme.iconColor,
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
                          ? const EmotionCalendarWidget()
                          : EmotionListWidget(),
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
