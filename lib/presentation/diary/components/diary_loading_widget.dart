import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/core/utils/delay_tween_animation.dart';

class DiaryLoadingWidget extends StatefulWidget {
  const DiaryLoadingWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<DiaryLoadingWidget> createState() => _DiaryLoadingWidgetState();
}

class _DiaryLoadingWidgetState extends State<DiaryLoadingWidget>
    with SingleTickerProviderStateMixin {
  final List<double> delays = [-0.9, -0.6, -0.3];
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
      //vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
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
                    opacity: DelayTween(begin: 0.0, end: 1.0, delay: delays[i])
                        .animate(_animationController),
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
          ),
        ),
        SizedBox(
          height: 8.h,
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 40.0.h),
          child: SvgPicture.asset(
            "lib/config/assets/images/character/onboarding2.svg",
            width: 350.w,
            height: 350.h,
          ),
        ),
      ],
    );
  }
}
