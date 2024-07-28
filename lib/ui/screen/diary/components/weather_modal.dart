import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/providers/diary/provider/diary_select_provider.dart';
import 'package:frontend/ui/components/bottom_button.dart';
import 'package:frontend/ui/screen/diary/components/weather_icon_button.dart';
import 'package:frontend/utils/utils.dart';

class WeatherModal extends ConsumerWidget {
  const WeatherModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 300.h,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.backgroundModal,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.w),
              topRight: Radius.circular(24.w),
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 28.w, top: 28.h),
                child: Row(
                  children: [
                    Text(
                      "날씨",
                      style: kHeader4Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 6.w, top: 75.h),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: ref.watch(diarySelectProvider).weatherDataList.length,
                  itemBuilder: (BuildContext context, int i) {
                    return Consumer(builder: (context, ref, child) {
                      return WeatherIconButton(
                        name: ref.watch(diarySelectProvider).weatherDataList[i].desc,
                        icon: ref.watch(diarySelectProvider).weatherDataList[i].weather,
                        selected: ref.watch(diarySelectProvider).selectedWeather == ref.watch(diarySelectProvider).weatherDataList[i],
                        onPressed: () {
                          GlobalUtils.setAnalyticsCustomEvent('Click_Diary_Weather_${ref.watch(diarySelectProvider).weatherDataList[i].id}');
                          ref.watch(diarySelectProvider.notifier).setSelectedWeather(ref.watch(diarySelectProvider).weatherDataList[i]);
                        },
                      );
                    });
                  },
                ),
              ),
              Consumer(builder: (context, ref, child) {
                return BottomButton(
                  title: '다음',
                  onTap: ref.watch(diarySelectProvider).selectedWeather.weather.isEmpty
                      ? null
                      : () {
                          GlobalUtils.setAnalyticsCustomEvent('Click_Diary_Next_WeatherToEmotion');
                          ref.watch(diarySelectProvider.notifier).popDownEmotionModal();
                        },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
