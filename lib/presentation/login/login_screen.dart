import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/presentation/home/home_screen.dart';
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
        backgroundColor: kOrange300Color,
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
                  "lib/config/assets/images/login/login_logo.svg",
                  width: 82.w,
                ),
              ),
            ),
            Center(
              child: SvgPicture.asset(
                "lib/config/assets/images/character/logo_text.svg",
                width: 82.w,
              ),
            ),
            SizedBox(
              height: 230.h,
            ),
            InkWell(
              onTap: () async {
                // await controller.connectKakaoLogin();
                Get.offAll(
                  () => const HomeScreen(),
                  binding: BindingsBuilder(
                    getHomeViewModelBinding,
                  ),
                );
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
                      // await controller.connectAppleLogin();
                      Get.offAll(
                        () => const HomeScreen(),
                        binding: BindingsBuilder(
                          getHomeViewModelBinding,
                        ),
                      );
                    },
                    child: const AppleLoginWidget(),
                  ),
            InkWell(
              onTap: () async {
                // await controller.connectAppleLogin();
                Get.offAll(
                  () => const HomeScreen(),
                  binding: BindingsBuilder(
                    getHomeViewModelBinding,
                  ),
                );
              },
              child: const AppleLoginWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
