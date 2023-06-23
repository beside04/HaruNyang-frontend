import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/presentation/login/components/kakao_login_widget.dart';
import 'package:frontend/core/utils/utils.dart';
import 'package:frontend/presentation/login/login_view_model.dart';
import 'package:get/get.dart';

import 'components/apple_login_widget.dart';

class LoginScreen extends GetView<LoginViewModel> {
  final bool isSignup;
  final bool isSocialKakao;

  const LoginScreen({
    Key? key,
    this.isSignup = false,
    this.isSocialKakao = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getLoginBinding();

    if (isSignup) {
      controller.signupAndLogin(isSocialKakao);
    }

    return DefaultLayout(
      screenName: 'Screen_Event_Login',
      child: WillPopScope(
        onWillPop: () async {
          bool backResult = GlobalUtils.onBackPressed();
          return await Future.value(backResult);
        },
        child: Scaffold(
          backgroundColor: kOrange300Color,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
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
      ),
    );
  }
}
