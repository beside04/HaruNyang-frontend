import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/presentation/components/bottom_button.dart';
import 'package:frontend/presentation/home/home_screen.dart';
import 'package:frontend/presentation/on_boarding/components/black_points.dart';
import 'package:frontend/presentation/on_boarding/on_boarding_finish/on_boarding_finish_viewmodel.dart';
import 'package:get/get.dart';

class OnBoardingFinishScreen extends GetView<OnBoardingFinishViewModel> {
  const OnBoardingFinishScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAll(
          () => const HomeScreen(),
          transition: Transition.cupertino,
        );
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BlackPoints(
                      blackNumber: 4,
                    ),
                    Padding(
                      padding: kPrimarySidePadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 40.h,
                          ),
                          Text(
                            "하루냥의",
                            style: kHeader2BlackStyle,
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          Text(
                            "집사 등록이 완료되었어요!",
                            style: kHeader2BlackStyle,
                          ),
                          SizedBox(
                            height: 210.h,
                          ),
                          Center(
                            child: SizedBox(
                              width: 240.w,
                              height: 240.h,
                              child: SvgPicture.asset(
                                "lib/config/assets/images/character/onboarding3.svg",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              BottomButton(
                title: '시작하기',
                onTap: () {
                  Get.offAll(
                    () => const HomeScreen(),
                    transition: Transition.cupertino,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
