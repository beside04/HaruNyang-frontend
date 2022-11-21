import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/core/utils/utils.dart';
import 'package:frontend/presentation/login/login_terms_information/login_terms_information_screen.dart';
import 'package:frontend/presentation/on_boarding/on_boarding_nickname/on_boarding_nickname_screen.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0.w),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: kKakaoPrimaryColor,
                ),
                width: 360.w,
                height: 56.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 95.0.w,
                      ),
                      child: SizedBox(
                        width: 27.w,
                        height: 27.h,
                        child: Image.asset(
                          'lib/config/assets/images/login/kakao_logo.png',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 7.w,
                    ),
                    Text(
                      "카카오톡으로 로그인",
                      style: kSubtitle1BlackStyle,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 12.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0.w),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: kBlackColor,
                ),
                width: 360.w,
                height: 56.h,
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 95.0.w,
                        top: 10.h,
                      ),
                      child: SizedBox(
                        width: 51.w,
                        height: 35.h,
                        child: Image.asset(
                          'lib/config/assets/images/login/apple_logo.png',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 138.0.w,
                        top: 18.h,
                      ),
                      child: Text(
                        "애플로 로그인",
                        style: kSubtitle1WhiteStyle,
                      ),
                    ),
                  ],
                ),
              ),
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
      ),
    );
  }
}
