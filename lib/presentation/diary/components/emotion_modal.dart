import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/presentation/components/bottom_button.dart';
import 'package:frontend/presentation/diary/components/emoticon_icon_button.dart';
import 'package:frontend/presentation/diary/diary_view_model.dart';
import 'package:frontend/presentation/diary/write_diary_screen.dart';
import 'package:get/get.dart';

import '../../../core/utils/utils.dart';

class EmotionModal extends GetView<DiaryViewModel> {
  final DateTime date;

  const EmotionModal({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedPositioned(
        duration: const Duration(milliseconds: 200),
        bottom: controller.isEmotionModal.value ? -276.h : 0,
        child: Obx(
          () => AnimatedContainer(
            duration: const Duration(milliseconds: 200),
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
                          "기분",
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
                      itemCount: controller.emoticonDataList.length,
                      itemBuilder: (BuildContext context, int i) {
                        return Obx(
                          () => EmoticonIconButton(
                            name: controller.emoticonDataList[i].desc,
                            icon: controller.emoticonDataList[i].emoticon,
                            selected: controller.selectedEmotion.value ==
                                controller.emoticonDataList[i],
                            onPressed: () {
                              GlobalUtils.setAnalyticsCustomEvent(
                                  'Click_Diary_Emotion_${controller.emoticonDataList[i].id}');
                              controller.setSelectedEmoticon(
                                  controller.emoticonDataList[i]);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  // Obx(
                  //   () => Padding(
                  //     padding: EdgeInsets.only(left: 6.w, top: 190.h),
                  //     child: controller.selectedEmotion.value.emoticon.isEmpty
                  //         ? Container()
                  //         : buildSlider(context),
                  //   ),
                  // ),
                  Obx(
                    () => BottomButton(
                      title: '일기쓰기',
                      onTap: controller.selectedEmotion.value.emoticon.isEmpty
                          ? null
                          : () {
                              GlobalUtils.setAnalyticsCustomEvent(
                                  'Click_Diary_Next_EmotionToWrite');
                              Get.to(
                                () => WriteDiaryScreen(
                                  date: date,
                                  emotion:
                                      controller.selectedEmotion.value.value,
                                  weather:
                                      controller.selectedWeather.value.value,
                                  isEditScreen: false,
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
            style: kHeader6Style.copyWith(
                color: Theme.of(context).colorScheme.textBody),
          ),
          SliderTheme(
            data: const SliderThemeData(
              trackHeight: 6,
              activeTickMarkColor: Colors.transparent,
              inactiveTickMarkColor: Colors.transparent,
              inactiveTrackColor: kGrayColor100,
              thumbColor: kWhiteColor,
              activeTrackColor: kOrange300Color,
              overlayColor: Colors.transparent,
              thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: 12,
                elevation: 2,
              ),
            ),
            child: Obx(
              () => Slider(
                value: controller.emotionNumberValue.value,
                min: 0,
                max: 3,
                divisions: 3,
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
