import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/presentation/login/login_screen.dart';
import 'package:frontend/presentation/on_boarding/on_boarding_nickname/on_boarding_nickname_screen.dart';
import 'package:frontend/presentation/profile/components/profile_button.dart';
import 'package:frontend/presentation/profile/profile_setting/profile_setting_view_model.dart';
import 'package:frontend/presentation/profile/profile_setting/withdraw/withdraw_screen.dart';
import 'package:get/get.dart';

class ProfileSettingScreen extends GetView<ProfileSettingViewModel> {
  final bool isKakaoLogin;

  const ProfileSettingScreen({
    Key? key,
    required this.isKakaoLogin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: kBlackColor),
        backgroundColor: kWhiteColor,
        title: Text(
          '내 정보 관리',
          style: kHeader3BlackStyle,
        ),
        centerTitle: false,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 12.h,
              color: const Color(0xffedebe8),
            ),
            ProfileButton(
              icon: const Icon(
                Icons.navigate_next,
                color: kGrayColor250,
              ),
              title: '닉네임 수정',
              onPressed: () {},
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 1.h,
              color: kGrayColor100,
            ),
            ProfileButton(
              icon: const Icon(
                Icons.navigate_next,
                color: kGrayColor250,
              ),
              title: '나이 수정',
              onPressed: () {},
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 1.h,
              color: kGrayColor100,
            ),
            ProfileButton(
              icon: const Icon(
                Icons.navigate_next,
                color: kGrayColor250,
              ),
              title: '직업 수정',
              onPressed: () {},
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 1.h,
              color: kGrayColor100,
            ),
            ProfileButton(
              icon: const Icon(
                Icons.navigate_next,
                color: kGrayColor250,
              ),
              title: '회원탈퇴',
              onPressed: () {
                Get.to(
                  () => WithdrawScreen(
                    isKakaoLogin: isKakaoLogin,
                  ),
                  binding: BindingsBuilder(
                    getWithdrawViewModelBinding,
                  ),
                );
              },
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 12.h,
              color: const Color(0xffedebe8),
            ),
            ProfileButton(
              icon: const Icon(
                Icons.navigate_next,
                color: kGrayColor250,
              ),
              title: '로그아웃',
              onPressed: () async {
                isKakaoLogin
                    ? await controller.kakaoLogout()
                    : await controller.appleLogout();
                Get.offAll(
                  const LoginScreen(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
