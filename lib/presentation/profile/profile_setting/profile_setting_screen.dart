import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/presentation/login/login_screen.dart';
import 'package:frontend/presentation/on_boarding/on_boarding_nickname/on_boarding_nickname_screen.dart';
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
      floatingActionButton: Padding(
        padding: kPrimarySidePadding,
        child: Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () async {
                  await controller.logout();
                  Get.offAll(
                    const LoginScreen(),
                  );
                },
                child: Text(
                  "로그아웃",
                  style: kBody1BlackStyle,
                ),
              ),
            ),
            Expanded(
              child: TextButton(
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
                child: Text(
                  "회원탈퇴",
                  style: kBody1BlackStyle,
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: kBlackColor),
        backgroundColor: kWhiteColor,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: kPrimaryPadding,
              child: Text(
                '내 정보 관리',
                style: kHeader1BlackStyle,
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 1, color: kGrayColor150),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 25.h),
                        child: Stack(
                          alignment: AlignmentDirectional.centerStart,
                          children: [
                            Text(
                              "나이 수정",
                              style: kSubtitle3BlackStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 1, color: kGrayColor150),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 25.h),
                        child: Stack(
                          alignment: AlignmentDirectional.centerStart,
                          children: [
                            Text(
                              "직업 수정",
                              style: kSubtitle3BlackStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 1, color: kGrayColor150),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 25.h),
                        child: Stack(
                          alignment: AlignmentDirectional.centerStart,
                          children: [
                            Text(
                              "직업 수정",
                              style: kSubtitle3BlackStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Get.to(
                        () => const OnBoardingNicknameScreen(),
                      );
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 1, color: kGrayColor150),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 25.h),
                        child: Stack(
                          alignment: AlignmentDirectional.centerStart,
                          children: [
                            Text(
                              "온보딩 수정 (테스트)",
                              style: kSubtitle3BlackStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
