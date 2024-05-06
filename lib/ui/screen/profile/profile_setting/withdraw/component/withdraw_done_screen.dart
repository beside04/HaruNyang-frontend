import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/ui/components/back_icon.dart';
import 'package:frontend/ui/components/bottom_button.dart';
import 'package:frontend/ui/layout/default_layout.dart';
import 'package:frontend/ui/screen/login/login_screen.dart';

class WithdrawDoneScreen extends StatelessWidget {
  const WithdrawDoneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      screenName: 'Screen_Event_Profile_MyInformation_Withdraw_Done',
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: BackIcon(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: kPrimaryPadding,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '그동안',
                      style: kHeader2Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                    ),
                    Text(
                      '하루냥을 이용해 주셔서',
                      style: kHeader2Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                    ),
                    Text(
                      '감사합니다.',
                      style: kHeader2Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                    ),
                    SizedBox(
                      height: 100.h,
                    ),
                    Center(
                      child: Image.asset(
                        "lib/config/assets/images/character/haru_withdraw.png",
                        width: 360.w,
                        height: 250.h,
                      ),
                    ),
                    // Center(
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(12),
                    //       color: Theme.of(context).colorScheme.surface_01,
                    //     ),
                    //     width: double.infinity,
                    //     height: 104.h,
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.center,
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         Text(
                    //           '나를 성장 시킨건 이별이 아니었다.',
                    //           style: kBody2Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                    //         ),
                    //         Text(
                    //           '함께했던 시간이었지',
                    //           style: kBody2Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                    //         ),
                    //         SizedBox(
                    //           height: 6.h,
                    //         ),
                    //         Text(
                    //           '하상욱',
                    //           style: kSubtitle1Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            BottomButton(
              title: "첫 화면으로",
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
