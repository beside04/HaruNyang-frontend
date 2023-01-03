import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/main_view_model.dart';
import 'package:frontend/presentation/diary/components/emotion_modal.dart';
import 'package:frontend/presentation/diary/components/past_diary_app_bar.dart';
import 'package:frontend/presentation/diary/components/weather_modal.dart';
import 'package:frontend/presentation/diary/diary_view_model.dart';
import 'package:get/get.dart';

class PastDiaryTestScreen extends GetView<DiaryViewModel> {
  final DateTime date;

  const PastDiaryTestScreen({
    Key? key,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getDiaryBinding();

    return WillPopScope(
      onWillPop: () async {
        controller.isEmotionModal.value
            ? Get.back()
            : controller.popUpEmotionModal();
        return false;
      },
      child: Scaffold(
        appBar: PastDiaryAppBar(date: date),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xffE69954), Color(0xffE4A469), Color(0xffE4A86F)],
            ),
          ),
          child: SafeArea(
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
                      Obx(
                        () => Text(
                          "${Get.find<MainViewModel>().state.value.nickname}님",
                          style: kHeader1BlackStyle,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(left: 24.w),
                    child: Obx(
                      () => Row(
                        children: [
                          controller.isEmotionModal.value
                              ? Text(
                                  "오늘 날씨 어때요?",
                                  style: Theme.of(context).textTheme.headline1,
                                )
                              : Text(
                                  "오늘 기분 어때요?",
                                  style: Theme.of(context).textTheme.headline1,
                                ),
                        ],
                      ),
                    )),
                SizedBox(height: 20.h),
                GetBuilder<DiaryViewModel>(builder: (context) {
                  return Expanded(
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: SvgPicture.asset(
                            controller.isEmotionModal.value
                                ? "lib/config/assets/images/character/weather1.svg"
                                : "lib/config/assets/images/character/weather2.svg",
                            width: 300.w,
                            height: 300.h,
                          ),
                        ),
                        const WeatherModal(),
                        const EmotionModal(),
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
