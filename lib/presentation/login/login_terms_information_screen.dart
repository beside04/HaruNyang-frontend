import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/presentation/login/components/term_buttons.dart';
import 'package:frontend/presentation/login/login_privacy_policy_screen.dart';
import 'package:frontend/presentation/login/login_terms_information_viewmodel.dart';
import 'package:frontend/presentation/login/login_terms_of_service_screen.dart';
import 'package:frontend/presentation/on_boarding/on_boarding_nickname_screen.dart';
import 'package:get/get.dart';

class LoginTermsInformationScreen
    extends GetView<LoginTermsInformationViewModel> {
  const LoginTermsInformationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginTermsInformationViewModel());

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 64.h,
          ),
          IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              size: 32.w,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15.h,
                ),
                Text(
                  "약관정보",
                  style: kHeader1BlackStyle,
                ),
                SizedBox(
                  height: 12.h,
                ),
                Text(
                  "댕청봇의 서비스 약관이에요.",
                  style: kRegular20GrayStyle,
                ),
                Text(
                  "필수적인 약관은 동의해야 이용할 수 있어요",
                  style: kRegular20GrayStyle,
                ),
                SizedBox(
                  height: 40.h,
                ),
                Obx(
                  () => TermButtons(
                    title: '이용약관 (필수)',
                    onTap: () async {
                      controller.isTermsAgree.value = await Get.to(
                        () => LoginTermsOfServiceScreen(),
                        transition: Transition.rightToLeft,
                      );
                    },
                    isAgree: controller.isTermsAgree.value,
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Obx(
                  () => TermButtons(
                    title: '개인정보 처리방침 (필수)',
                    onTap: () async {
                      controller.isPrivacyPolicyAgree.value = await Get.to(
                        () => LoginPrivacyPolicyScreen(),
                        transition: Transition.rightToLeft,
                      );
                    },
                    isAgree: controller.isPrivacyPolicyAgree.value,
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                TermButtons(
                  title: '전체 동의하기',
                  onTap: () {
                    if (controller.isTermsAgree.value &&
                        controller.isPrivacyPolicyAgree.value) {
                      Get.offAll(() => OnBoardingNicknameScreen());
                    }
                  },
                  isAgree: controller.isTermsAgree.value &&
                      controller.isPrivacyPolicyAgree.value,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
