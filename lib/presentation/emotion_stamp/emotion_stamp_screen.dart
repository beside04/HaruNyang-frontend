import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/core/utils/library/date_time_spinner/base_picker_model.dart';
import 'package:frontend/core/utils/library/date_time_spinner/date_picker_theme.dart'
    as picker_theme;
import 'package:frontend/core/utils/library/date_time_spinner/date_time_spinner.dart';
import 'package:frontend/core/utils/library/date_time_spinner/i18n_model.dart';
import 'package:frontend/global_controller/diary/diary_controller.dart';
import 'package:frontend/main.dart';
import 'package:frontend/main_view_model.dart';
import 'package:frontend/presentation/components/dialog_button.dart';
import 'package:frontend/presentation/components/dialog_component.dart';
import 'package:frontend/presentation/emotion_stamp/components/emotion_calendar_widget.dart';
import 'package:frontend/presentation/emotion_stamp/components/emotion_list_widget.dart';
import 'package:frontend/presentation/login/login_screen.dart';
import 'package:frontend/res/constants.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';

import '../../core/utils/utils.dart';

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
    TargetPlatform os = Theme.of(context).platform;

    BannerAd banner = BannerAd(
      listener: BannerAdListener(
        onAdFailedToLoad: (Ad ad, LoadAdError error) {},
        onAdLoaded: (_) {},
      ),
      size: AdSize.banner,
      adUnitId: UNIT_ID[os == TargetPlatform.iOS ? 'ios' : 'android']!,
      request: const AdRequest(),
    )..load();

    return DefaultLayout(
      screenName: 'Screen_Event_Main_EmotionCalendar',
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          actions: [
            Obx(
              () => IconButton(
                onPressed: () {
                  diaryController.toggleCalendarMode();
                },
                icon: diaryController.state.value.isCalendar
                    ? SvgPicture.asset(
                        "lib/config/assets/images/diary/dark_mode/list.svg",
                        color: Theme.of(context).colorScheme.iconColor,
                      )
                    : SvgPicture.asset(
                        "lib/config/assets/images/diary/dark_mode/calendar.svg",
                        color: Theme.of(context).colorScheme.iconColor,
                      ),
              ),
            ),
          ],
          title: Obx(
            () => InkWell(
              onTap: () {
                GlobalUtils.setAnalyticsCustomEvent('Click_Change_Month');
                DatePicker.showPicker(
                  context,
                  pickerModel: YearMonthModel(
                    currentTime:
                        diaryController.state.value.focusedCalendarDate,
                    maxTime: DateTime.now(),
                    minTime: DateTime(2000, 1),
                    locale: LocaleType.ko,
                  ),
                  showTitleActions: true,
                  onConfirm: (date) {
                    diaryController.onPageChanged(date);
                  },
                  locale: LocaleType.ko,
                  theme: picker_theme.DatePickerTheme(
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
                      width: 4.w,
                    ),
                    Image.asset(
                      "lib/config/assets/images/home/dark_mode/system-arrow.png",
                      width: 24,
                      height: 24,
                      color: Theme.of(context).colorScheme.iconColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Obx(
                  () => PageTransitionSwitcher(
                    duration: const Duration(milliseconds: 300),
                    reverse: !diaryController.state.value.isCalendar,
                    transitionBuilder: (Widget child,
                        Animation<double> animation,
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
              SizedBox(
                height: 100.h,
                child: GestureDetector(
                  onTap: () {
                    GlobalUtils.setAnalyticsCustomEvent('Click_AD');
                  },
                  child: AdWidget(
                    ad: banner,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
