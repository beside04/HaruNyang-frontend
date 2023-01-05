import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/presentation/components/bottom_button.dart';
import 'package:frontend/presentation/diary/components/weather_icon_button.dart';
import 'package:frontend/presentation/diary/diary_view_model.dart';
import 'package:frontend/res/constants.dart';
import 'package:get/get.dart';

class WeatherModal extends GetView<DiaryViewModel> {
  const WeatherModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 276.h,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
            color: Theme.of(context).colorScheme.darkTheme_50_850,
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 28.w, top: 28.h),
                child: Row(
                  children: [
                    Text(
                      "날씨",
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 6.w, top: 75.h),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: weatherDataList.length,
                  itemBuilder: (BuildContext context, int i) {
                    return Obx(
                      () => WeatherIconButton(
                        name: weatherDataList[i].name,
                        icon: weatherDataList[i].icon,
                        selected:
                            controller.weatherStatus.value == Weather.values[i],
                        onPressed: () {
                          controller.weatherStatus.value = Weather.values[i];
                        },
                      ),
                    );
                  },
                ),
              ),
              Obx(
                () => BottomButton(
                  title: '다음으로',
                  onTap: controller.weatherStatus.value == null
                      ? null
                      : () {
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
