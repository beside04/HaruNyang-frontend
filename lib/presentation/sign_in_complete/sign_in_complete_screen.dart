import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/core/utils/utils.dart';
import 'package:frontend/presentation/components/bottom_button.dart';
import 'package:frontend/presentation/on_boarding/on_boarding_nickname/on_boarding_nickname_screen.dart';
import 'package:get/get.dart';

class SignInCompleteScreen extends StatelessWidget {
  const SignInCompleteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool backResult = GlobalUtils.onBackPressed();
        return await Future.value(backResult);
      },
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: kPrimarySidePadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 40.h,
                          ),
                          Text(
                            "가입완료",
                            style: kHeader2Style.copyWith(
                                color: Theme.of(context).colorScheme.textTitle),
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          Text(
                            "이제 하루냥과 함께 하루를 기록해보아요!",
                            style: kBody2Style.copyWith(
                                color: Theme.of(context).colorScheme.textTitle),
                          ),
                          SizedBox(
                            height: 158.h,
                          ),
                          Center(
                            child: SvgPicture.asset(
                              "lib/config/assets/images/character/character5.svg",
                              width: 375.w,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              BottomButton(
                title: '하루냥 시작하기',
                onTap: () async {
                  Get.offAll(
                    () => const OnBoardingNicknameScreen(),
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
