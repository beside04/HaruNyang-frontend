import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/presentation/diary/diary_view_model.dart';
import 'package:get/get.dart';

class DiaryPicture extends GetView<DiaryViewModel> {
  const DiaryPicture({super.key});

  @override
  Widget build(BuildContext context) {
    return controller.isEmotionModal.value
        ? Align(
            alignment: Alignment.topCenter,
            child: SvgPicture.asset(
              "lib/config/assets/images/character/weather1.svg",
              width: 300.w,
              height: 300.h,
            ),
          )
        : Align(
            alignment: Alignment.topCenter,
            child: SvgPicture.asset(
              "lib/config/assets/images/character/weather2.svg",
              width: 300.w,
              height: 300.h,
            ),
          );
  }
}
