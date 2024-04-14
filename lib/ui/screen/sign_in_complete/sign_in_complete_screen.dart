import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/core/utils/utils.dart';
import 'package:frontend/ui/components/bottom_button.dart';
import 'package:frontend/ui/layout/default_layout.dart';
import 'package:frontend/ui/screen/on_boarding/on_boarding_nickname/on_boarding_nickname_screen.dart';

class SignInCompleteScreen extends StatelessWidget {
  final String? email;
  final String loginType;
  final String socialId;

  const SignInCompleteScreen({
    Key? key,
    required this.email,
    required this.loginType,
    required this.socialId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      screenName: 'Screen_Event_SignInComplete',
      child: WillPopScope(
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
                              style: kHeader2Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Text(
                              "이제 하루냥과 함께 하루를 기록해보아요!",
                              style: kBody2Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                            ),
                            SizedBox(
                              height: 158.h,
                            ),
                            Center(
                              child: Image.asset(
                                "lib/config/assets/images/character/character4.png",
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OnBoardingNicknameScreen(
                          email: email,
                          loginType: loginType,
                          socialId: socialId,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
