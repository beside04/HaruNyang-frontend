import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/presentation/components/bottom_button.dart';
import 'package:frontend/presentation/login/login_screen.dart';
import 'package:get/get.dart';

class WithdrawDoneScreen extends StatelessWidget {
  const WithdrawDoneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackGroundLightColor,
        elevation: 0,
      ),
      body: Padding(
        padding: kPrimaryPadding,
        child: Stack(
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '그동안',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  Text(
                    '하루냥을 이용해 주셔서',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  Text(
                    '감사합니다.',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  SizedBox(
                    height: 100.h,
                  ),
                  Center(
                    child: SvgPicture.asset(
                      "lib/config/assets/images/character/intro1.svg",
                      width: 280.w,
                      height: 280.h,
                    ),
                  ),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      width: double.infinity,
                      height: 104.h,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '나를 성장 시킨건 이별이 아니었다.',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Text(
                            '함께했던 시간이었지',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          Text(
                            '하상욱',
                            //style: kSubtitle1BlackStyle,
                            style: Theme.of(context).textTheme.subtitle1,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            BottomButton(
                title: "첫 화면으로",
                onTap: () {
                  Get.offAll(
                    () => const LoginScreen(),
                    binding: BindingsBuilder(
                      getLoginBinding,
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
