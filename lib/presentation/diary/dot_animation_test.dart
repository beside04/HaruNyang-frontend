import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/core/utils/delay_tween_animation.dart';
import 'package:frontend/presentation/diary/dot_animation_test_view_model.dart';
import 'package:get/get.dart';

class DotAnimationTest extends GetView<DotAnimationTestViewModel> {
  const DotAnimationTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 108.w,
      height: 52.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0.w),
        color: kWhiteColor,
      ),
      child: Padding(
        padding: kPrimaryPadding,
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          itemBuilder: (BuildContext context, int i) {
            return FadeTransition(
              opacity:
                  DelayTween(begin: 0.0, end: 1.0, delay: controller.delays[i])
                      .animate(controller.animationController),
              child: Row(
                children: [
                  SizedBox(
                    width: 12.w,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: kBlackColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  i == 2
                      ? Container()
                      : SizedBox(
                          width: 14.w,
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
