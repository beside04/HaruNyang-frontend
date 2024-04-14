import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/ui/layout/default_layout.dart';
import 'package:frontend/core/utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
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
                  // onTap: () async {
                  //   await controller.connectKakaoLogin();
                  // },
                  // child: const KakaoLoginWidget(),
                  ),
              SizedBox(
                height: 12.h,
              ),
              // GetPlatform.isAndroid
              //     ? Container()
              //     : InkWell(
              //   onTap: () async {
              //     await controller.connectAppleLogin();
              //   },
              //   child: const AppleLoginWidget(),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
