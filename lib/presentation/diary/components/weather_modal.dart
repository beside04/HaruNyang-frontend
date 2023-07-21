import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/presentation/components/bottom_button.dart';
import 'package:frontend/presentation/diary/components/weather_icon_button.dart';
import 'package:frontend/presentation/diary/diary_view_model.dart';
import 'package:get/get.dart';

import '../../../core/utils/utils.dart';

class WeatherModal extends GetView<DiaryViewModel> {
  const WeatherModal({super.key});

  @override
  Widget build(BuildContext context) {
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
                      style: kHeader4Style.copyWith(
                          color: Theme.of(context).colorScheme.textTitle),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 6.w, top: 75.h),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.weatherDataList.length,
                  itemBuilder: (BuildContext context, int i) {
                    return Obx(
                      () => WeatherIconButton(
                        name: controller.weatherDataList[i].desc,
                        icon: controller.weatherDataList[i].weather,
                        selected: controller.selectedWeather.value ==
                            controller.weatherDataList[i],
                        onPressed: () {
                          GlobalUtils.setAnalyticsCustomEvent(
                              'Click_Diary_Weather_${controller.weatherDataList[i].id}');
                          controller.selectedWeather.value =
                              controller.weatherDataList[i];
                        },
                      ),
                    );
                  },
                ),
              ),
              Obx(
                () => BottomButton(
                  title: '다음',
                  onTap: controller.selectedWeather.value.weather.isEmpty
                      ? null
                      : () {
                          GlobalUtils.setAnalyticsCustomEvent(
                              'Click_Diary_Next_WeatherToEmotion');
                          controller.popDownEmotionModal();
                        },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
