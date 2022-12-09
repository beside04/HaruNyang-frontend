import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/presentation/components/bottom_button.dart';
import 'package:frontend/presentation/diary/components/weather_icon.dart';
import 'package:frontend/presentation/diary/diary_view_model.dart';
import 'package:frontend/res/constants.dart';
import 'package:get/get.dart';

class EmotionModal extends GetView<DiaryViewModel> {
  const EmotionModal({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller.animationController,
      builder: (BuildContext context, Widget? child) {
        return Transform.scale(
          scale: controller.animationController.value < 0.8
              ? 0.9
              : controller.animationController.value,
          child: Transform.translate(
            offset: Offset(
              0.0,
              -30 + controller.animationController.value * 30,
            ),
            child: Opacity(
              opacity: controller.animationController.value < 0.1
                  ? 0.5
                  : controller.animationController.value,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    color: kWhiteColor,
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 28.w, top: 28.w),
                        child: Row(
                          children: [
                            Text(
                              "기분",
                              style: kHeader3BlackStyle,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 6.w, top: 75.w),
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.weatherDataList.length,
                          itemBuilder: (BuildContext context, int i) {
                            return Obx(
                              () => WeatherIconButton(
                                name: controller.weatherDataList[i].name,
                                icon: controller.weatherDataList[i].icon,
                                selected: controller.weatherStatus.value ==
                                    Weather.values[i],
                                onPressed: () {
                                  controller.weatherStatus.value =
                                      Weather.values[i];
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      BottomButton(
                        title: '다음으로',
                        onTap: controller.weatherStatus.value == null
                            ? null
                            : () {
                                controller.animationController.reverse();
                                controller.swapStackChildren2();
                              },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
