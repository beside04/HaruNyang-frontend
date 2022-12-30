import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/presentation/login/components/kakao_login_widget.dart';
import 'package:frontend/core/utils/utils.dart';
import 'package:frontend/presentation/login/login_view_model.dart';
import 'package:get/get.dart';

import 'components/apple_login_widget.dart';

class LoginScreen extends GetView<LoginViewModel> {
  final bool isSignup;

  const LoginScreen({
    Key? key,
    this.isSignup = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isSignup) {
      controller.signupAndLogin();
    }

    return WillPopScope(
      onWillPop: () async {
        bool backResult = GlobalUtils.onBackPressed();
        return await Future.value(backResult);
      },
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 165.h,
              ),
              child: Center(
                child: SvgPicture.asset(
                  "lib/config/assets/images/character/weather1.svg",
                  width: 280.w,
                  height: 280.h,
                ),
              ),
            ),
            SizedBox(
              height: 50.h,
            ),
            Center(
              child: Text(
                "하루냥과 함께해볼까요?",
                style: kHeader1BlackStyle,
              ),
            ),
            SizedBox(
              height: 54.h,
            ),
            InkWell(
              onTap: () async {
                await controller.connectKakaoLogin();
              },
              child: const KakaoLoginWidget(),
            ),
            SizedBox(
              height: 12.h,
            ),
            GetPlatform.isAndroid
                ? Container()
                : InkWell(
                    onTap: () async {
                      await controller.connectAppleLogin();
                    },
                    child: const AppleLoginWidget(),
                  ),
            SizedBox(
              height: 20.h,
            ),
          ],
        ),
      ),
    );
  }
}
