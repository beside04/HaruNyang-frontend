import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/main_view_model.dart';
import 'package:frontend/presentation/diary/components/diary_app_bar.dart';
import 'package:frontend/presentation/diary/components/emotion_modal.dart';
import 'package:frontend/presentation/diary/components/weather_modal.dart';
import 'package:frontend/presentation/diary/diary_view_model.dart';
import 'package:get/get.dart';

class DiaryScreen extends GetView<DiaryViewModel> {
  final DateTime? date;

  const DiaryScreen({
    super.key,
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    getDiaryBinding();

    if (date != null) {
      controller.nowDate.value = date!;
    }
    return Scaffold(
      appBar: DiaryAppBar(
        date: date != null ? date! : DateTime.now(),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: Get.find<MainViewModel>().isDarkMode.value
                ? [kGrayColor950, kGrayColor950]
                : [
                    const Color(0xffffac60),
                    const Color(0xffffc793),
                  ],
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
                        "${Get.find<MainViewModel>().state.value.nickname}님,",
                        style: kHeader1Style.copyWith(
                            color: Theme.of(context).colorScheme.textTitle),
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
                                style: kHeader1Style.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .textTitle),
                              )
                            : Text(
                                "오늘 기분 어때요?",
                                style: kHeader1Style.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .textTitle),
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
    );
  }
}
