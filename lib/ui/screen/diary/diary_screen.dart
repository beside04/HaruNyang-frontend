import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/core/utils/utils.dart';
import 'package:frontend/domain/model/emoticon_weather/emoticon_data.dart';
import 'package:frontend/domain/model/emoticon_weather/weather_data.dart';
import 'package:frontend/domains/diary/provider/diary_select_provider.dart';
import 'package:frontend/domains/on_boarding/provider/on_boarding_provider.dart';
import 'package:frontend/ui/screen/diary/components/diary_app_bar.dart';
import 'package:frontend/ui/screen/diary/components/emotion_modal.dart';
import 'package:frontend/ui/screen/diary/components/weather_modal.dart';
import 'package:frontend/ui/screen/home/home_screen.dart';

class DiaryScreen extends ConsumerStatefulWidget {
  const DiaryScreen({
    super.key,
    this.date,
  });

  final DateTime? date;

  @override
  DiaryScreenState createState() => DiaryScreenState();
}

class DiaryScreenState extends ConsumerState<DiaryScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.watch(diarySelectProvider.notifier).setSelectedEmoticon(const EmoticonData(emoticon: '', value: '', desc: ''));
      ref.watch(diarySelectProvider.notifier).setSelectedWeather(const WeatherData(weather: '', value: '', desc: ''));

      ref.watch(diarySelectProvider.notifier).popUpEmotionModal();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      screenName: 'Screen_Event_Main_WriteDiary',
      child: WillPopScope(
        onWillPop: () async {
          if (ref.watch(diarySelectProvider).isEmotionModal) {
            GlobalUtils.setAnalyticsCustomEvent('Click_Diary_BackToEmotionCalendar');
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);
          } else {
            GlobalUtils.setAnalyticsCustomEvent('Click_Diary_BackToWeather');
            ref.watch(diarySelectProvider.notifier).popUpEmotionModal();
          }

          return false;
        },
        child: Scaffold(
          appBar: DiaryAppBar(
            date: widget.date != null ? widget.date! : DateTime.now(),
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: Theme.of(context).colorScheme.brightness == Brightness.dark
                    ? [kGrayColor950, kGrayColor950]
                    : [
                        const Color(0xffffac60),
                        const Color(0xffffc793),
                      ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 8.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 24.w),
                  child: Row(
                    children: [
                      Consumer(builder: (context, ref, child) {
                        return Text(
                          "${ref.watch(onBoardingProvider).nickname}님,",
                          style: kHeader2Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                        );
                      }),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 24.w),
                  child: Consumer(builder: (context, ref, child) {
                    return Row(
                      children: [
                        ref.watch(diarySelectProvider).isEmotionModal
                            ? Text(
                                "오늘 날씨 어때요?",
                                style: kHeader2Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                              )
                            : Text(
                                "오늘 기분 어때요?",
                                style: kHeader2Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                              ),
                      ],
                    );
                  }),
                ),
                SizedBox(height: 20.h),
                Consumer(builder: (context, ref, child) {
                  return Expanded(
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Image.asset(
                            ref.watch(diarySelectProvider).isEmotionModal ? "lib/config/assets/images/character/character1.png" : "lib/config/assets/images/character/character2.png",
                            width: 320.w,
                            height: 320.h,
                          ),
                        ),
                        const WeatherModal(),
                        EmotionModal(
                          date: widget.date != null ? widget.date! : DateTime.now(),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
