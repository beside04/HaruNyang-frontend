import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/core/utils/library/date_time_spinner/base_picker_model.dart';
import 'package:frontend/core/utils/library/date_time_spinner/date_picker_theme.dart';
import 'package:frontend/core/utils/library/date_time_spinner/date_time_spinner.dart';
import 'package:frontend/core/utils/library/date_time_spinner/i18n_model.dart';
import 'package:frontend/global_controller/diary/diary_controller.dart';
import 'package:frontend/main_view_model.dart';
import 'package:frontend/presentation/emotion_stamp/components/emotion_calendar_widget.dart';
import 'package:frontend/presentation/emotion_stamp/components/emotion_list_widget.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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

class EmotionStampScreen extends StatefulWidget {
  const EmotionStampScreen({super.key});

  @override
  State<EmotionStampScreen> createState() => _EmotionStampScreenState();
}

class _EmotionStampScreenState extends State<EmotionStampScreen> {
  final diaryController = Get.find<DiaryController>();
  final mainViewController = Get.find<MainViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Container(
            color: Theme.of(context).colorScheme.border,
            height: 1.0,
          ),
        ),
        actions: [
          Obx(
            () => IconButton(
              onPressed: () {
                diaryController.toggleCalendarMode();
              },
              icon: diaryController.state.value.isCalendar
                  ? mainViewController.isDarkMode.value
                      ? SvgPicture.asset(
                          "lib/config/assets/images/diary/dark_mode/list.svg",
                        )
                      : SvgPicture.asset(
                          "lib/config/assets/images/diary/light_mode/list.svg",
                        )
                  : mainViewController.isDarkMode.value
                      ? SvgPicture.asset(
                          "lib/config/assets/images/diary/dark_mode/calendar.svg",
                        )
                      : SvgPicture.asset(
                          "lib/config/assets/images/diary/light_mode/calendar.svg",
                        ),
            ),
          )
        ],
        title: Obx(
          () => InkWell(
            onTap: () {
              DatePicker.showPicker(
                context,
                pickerModel: YearMonthModel(
                  currentTime: diaryController.state.value.focusedCalendarDate,
                  maxTime: DateTime(2099, 12),
                  minTime: DateTime(2000, 1),
                  locale: LocaleType.ko,
                ),
                showTitleActions: true,
                onConfirm: (date) {
                  diaryController.onPageChanged(date);
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
                    DateFormat('yyyy년 M월').format(
                        diaryController.state.value.focusedCalendarDate),
                    style: kHeader4Style.copyWith(
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
                  reverse: !diaryController.state.value.isCalendar,
                  transitionBuilder: (Widget child, Animation<double> animation,
                      Animation<double> secondaryAnimation) {
                    return SharedAxisTransition(
                      animation: animation,
                      secondaryAnimation: secondaryAnimation,
                      transitionType: SharedAxisTransitionType.horizontal,
                      child: child,
                    );
                  },
                  child: diaryController.state.value.isCalendarLoading
                      ? const Center(child: CircularProgressIndicator())
                      : diaryController.state.value.isCalendar
                          ? const EmotionCalendarWidget()
                          : const EmotionListWidget(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
