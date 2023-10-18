import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/domains/login/provider/login_provider.dart';
import 'package:frontend/main_view_model.dart';
import 'package:frontend/core/utils/utils.dart';
import 'package:frontend/ui/screen/login/components/apple_login_widget.dart';
import 'package:frontend/ui/screen/login/components/kakao_login_widget.dart';

class LoginScreen extends ConsumerWidget {
  final bool isSignup;
  final String loginType;

  const LoginScreen({
    Key? key,
    this.isSignup = false,
    this.loginType = "kakao",
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use context.read or watch to get the LoginViewModel

    if (isSignup) {
      ref.watch(loginProvider.notifier).signupAndLogin(loginType);
    }

    return DefaultLayout(
      screenName: 'Screen_Event_Login',
      child: WillPopScope(
        onWillPop: () async {
          bool backResult = GlobalUtils.onBackPressed();
          return await Future.value(backResult);
        },
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 250.h,
                ),
                child: Center(
                    child: Theme.of(context).colorScheme.brightness == Brightness.dark
                        ? Image.asset(
                            "lib/config/assets/images/login/login_logo_dark.png",
                            width: 92.w,
                          )
                        : Image.asset(
                            "lib/config/assets/images/login/login_logo_light.png",
                            width: 92.w,
                          )),
              ),
              SizedBox(
                height: Platform.isAndroid ? 310.h : 230.h,
              ),
              InkWell(
                onTap: () async {
                  await ref.watch(loginProvider.notifier).connectKakaoLogin();
                },
                child: const KakaoLoginWidget(),
              ),
              SizedBox(
                height: 12.h,
              ),
              Platform.isAndroid
                  ? Container()
                  : InkWell(
                      onTap: () async {
                        await ref.watch(loginProvider.notifier).connectAppleLogin();
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
