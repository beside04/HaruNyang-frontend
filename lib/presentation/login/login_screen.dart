import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/config/theme/theme_data.dart';
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
        backgroundColor: Theme.of(context).colorScheme.primaryColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 250.h,
              ),
              child: Center(
                child: SvgPicture.asset(
                  "lib/config/assets/images/character/character11.svg",
                  width: 100.w,
                  height: 80.h,
                ),
              ),
            ),
            Center(
              child: SvgPicture.asset(
                "lib/config/assets/images/character/logo_text.svg",
              ),
            ),
            SizedBox(
              height: 230.h,
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
          ],
        ),
      ),
    );
  }
}
