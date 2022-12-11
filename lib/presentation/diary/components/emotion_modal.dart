import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/presentation/components/bottom_button.dart';
import 'package:frontend/presentation/diary/components/diary_icon_button.dart';
import 'package:frontend/presentation/diary/diary_view_model.dart';
import 'package:frontend/presentation/diary/write_diary_screen.dart';
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
                        padding: EdgeInsets.only(left: 28.w, top: 28.h),
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
                        padding: EdgeInsets.only(left: 6.w, top: 75.h),
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: emotionDataList.length,
                          itemBuilder: (BuildContext context, int i) {
                            return Obx(
                              () => DiaryIconButton(
                                name: emotionDataList[i].name,
                                icon: emotionDataList[i].icon,
                                selected: controller.emotionStatus.value ==
                                    Emotion.values[i],
                                onPressed: () {
                                  controller.emotionStatus.value =
                                      Emotion.values[i];
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      Obx(
                        () => Padding(
                          padding: EdgeInsets.only(left: 6.w, top: 184.h),
                          child: controller.emotionStatus.value == null
                              ? Container()
                              : buildSlider(),
                        ),
                      ),
                      Obx(
                        () => BottomButton(
                          title: '일기쓰기',
                          onTap: controller.emotionStatus.value == null
                              ? null
                              : () {
                                  Get.to(() => WriteDiaryScreen(
                                        date: controller.nowDate.value,
                                        emotion:
                                            controller.emotionStatus.value!,
                                        weather:
                                            controller.weatherStatus.value!,
                                      ));
                                  // controller.animationController.reverse();
                                  // controller.swapStackChildren2();
                                },
                        ),
                      )
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

  Widget buildSlider() {
    return Obx(() => Column(
          children: [
            controller.numberValue.value < 2.0
                ? Text(
                    "전혀",
                    style: kSubtitle3BlackStyle,
                  )
                : controller.numberValue.value < 4.0
                    ? Text(
                        "조금?",
                        style: kSubtitle3BlackStyle,
                      )
                    : controller.numberValue.value < 6.0
                        ? Text(
                            "그럭저럭",
                            style: kSubtitle3BlackStyle,
                          )
                        : controller.numberValue.value < 8.0
                            ? Text(
                                "맞아!",
                                style: kSubtitle3BlackStyle,
                              )
                            : Text(
                                "진짜 엄청 대박!!",
                                style: kSubtitle3BlackStyle,
                              ),
            SliderTheme(
              data: const SliderThemeData(
                trackHeight: 6,
                activeTickMarkColor: Colors.transparent,
                inactiveTickMarkColor: Colors.transparent,
                inactiveTrackColor: kGrayColor100,
                thumbColor: kWhiteColor,
                activeTrackColor: kPrimaryColor,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12),
              ),
              child: Obx(
                () => Slider(
                  value: controller.numberValue.value,
                  min: 0,
                  max: 10,
                  divisions: 10,
                  onChanged: (value) {
                    controller.numberValue.value = value;
                  },
                ),
              ),
            ),
          ],
        ));
  }
}
