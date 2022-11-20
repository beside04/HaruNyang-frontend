import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/presentation/login/components/kakao_login_widget.dart';
import 'package:frontend/presentation/login/login_terms_information/login_terms_information_screen.dart';
import 'package:frontend/presentation/login/login_view_model.dart';
import 'package:frontend/presentation/on_boarding/on_boarding_nickname/on_boarding_nickname_screen.dart';
import 'package:get/get.dart';

import 'components/apple_login_widget.dart';

class LoginScreen extends GetView<LoginViewModel> {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 165.h,
              left: 56.w,
            ),
            child: Image.asset(
              "lib/config/assets/images/temp_img.png",
              width: 293.w,
              height: 285.h,
            ),
          ),
          SizedBox(
            height: 54.h,
          ),
          Center(
            child: Text(
              "댕청봇과 함께해볼까요?",
              style: kHeader1BlackStyle,
            ),
          ),
          SizedBox(
            height: 54.h,
          ),
          InkWell(
            onTap: () async {
              await controller.login();
            },
            child: const KakaoLoginWidget(),
          ),
          SizedBox(
            height: 12.h,
          ),
          InkWell(
            onTap: () {},
            child: const AppleLoginWidget(),
          ),
          SizedBox(
            height: 20.h,
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 17.w,
            ),
            child: Text.rich(
              TextSpan(
                text: '로그인시 댕청봇의 ',
                style: kSubtitle2BlackStyle,
                children: const [
                  TextSpan(
                    text: '이용약관',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  TextSpan(
                    text: '과 ',
                  ),
                  TextSpan(
                    text: '개인정보 보호 정책',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  TextSpan(
                    text: '을 \n이미 확인했음을 간주하고 진행됩니다.',
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Get.offAll(
                    OnBoardingNicknameScreen(),
                  );
                },
                child: const Text('온보딩 이동'),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  Get.to(
                    () => const LoginTermsInformationScreen(),
                  );
                },
                child: const Text('이용약관 이동'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
