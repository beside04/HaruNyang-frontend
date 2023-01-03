import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/presentation/components/bottom_button.dart';
import 'package:frontend/presentation/diary/components/emoticon_icon_button.dart';
import 'package:frontend/presentation/diary/diary_view_model.dart';
import 'package:frontend/presentation/diary/write_diary_screen.dart';
import 'package:get/get.dart';

class EmotionModal extends GetView<DiaryViewModel> {
  const EmotionModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedPositioned(
        duration: const Duration(milliseconds: 200),
        bottom: controller.isEmotionModal.value ? -276 : 0,
        child: Obx(
          () => AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: MediaQuery.of(context).size.width,
            height: controller.selectedEmotion.value.emoticon.isEmpty ||
                    controller.isEmotionModal.value
                ? 276.h
                : 375.h,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Theme.of(context).colorScheme.secondary,
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 28.w, top: 28.h),
                    child: Row(
                      children: [
                        Text(
                          "기분",
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
                      itemCount: controller.emoticonDataList.length,
                      itemBuilder: (BuildContext context, int i) {
                        return Obx(
                          () => EmoticonIconButton(
                            name: controller.emoticonDataList[i].desc,
                            icon: controller.emoticonDataList[i].emoticon,
                            selected: controller.selectedEmotion.value ==
                                controller.emoticonDataList[i],
                            onPressed: () {
                              controller.setSelectedEmoticon(
                                  controller.emoticonDataList[i]);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Obx(
                    () => Padding(
                      padding: EdgeInsets.only(left: 6.w, top: 201.h),
                      child: controller.selectedEmotion.value.emoticon.isEmpty
                          ? Container()
                          : buildSlider(context),
                    ),
                  ),
                  Obx(
                    () => BottomButton(
                      title: '일기쓰기',
                      onTap: controller.selectedEmotion.value.emoticon.isEmpty
                          ? null
                          : () {
                              Get.to(
                                () => WriteDiaryScreen(
                                  date: controller.nowDate.value,
                                  emotion: controller.selectedEmotion.value,
                                  weather: controller.weatherStatus.value!,
                                  emoticonIndex:
                                      (controller.emotionNumberValue.value * 10)
                                          .toInt(),
                                ),
                              );
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
  }

  Widget buildSlider(context) {
    return Obx(
      () => Column(
        children: [
          Text(
            controller.emotionTextValue.value,
            style: Theme.of(context).textTheme.headline6,
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
                value: controller.emotionNumberValue.value,
                min: 0,
                max: 10,
                divisions: 10,
                onChanged: (value) {
                  controller.emotionNumberValue.value = value;
                  controller.getEmotionValue();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
