import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/main_view_model.dart';
import 'package:frontend/presentation/diary/components/diary_app_bar.dart';
import 'package:frontend/presentation/diary/diary_view_model.dart';
import 'package:get/get.dart';

class DiaryScreen extends GetView<DiaryViewModel> {
  const DiaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    getDiaryBinding();

    return Scaffold(
      appBar: DiaryAppBar(
        date: DateTime.now(),
      ),
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
                                style: kHeader1BlackStyle,
                              )
                            : Text(
                                "오늘 기분 어때요?",
                                style: kHeader1BlackStyle,
                              ),
                      ],
                    ),
                  )),
              SizedBox(height: 20.h),
              GetBuilder<DiaryViewModel>(builder: (context) {
                return Expanded(
                  child: Stack(
                    children: [
                      ...controller.stackChildren,
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
