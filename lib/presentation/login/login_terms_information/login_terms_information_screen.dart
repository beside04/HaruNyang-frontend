import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/presentation/login/components/term_buttons.dart';
import 'package:frontend/presentation/login/login_terms_information/login_privacy_policy/login_privacy_policy_screen.dart';
import 'package:frontend/presentation/login/login_terms_information/login_terms_information_viewmodel.dart';
import 'package:frontend/presentation/login/login_terms_information/login_terms_of_service/login_terms_of_service_screen.dart';
import 'package:frontend/presentation/on_boarding/on_boarding_nickname/on_boarding_nickname_screen.dart';
import 'package:get/get.dart';

class LoginTermsInformationScreen
    extends GetView<LoginTermsInformationViewModel> {
  final String email;
  final String socialId;
  final bool isSocialKakao;

  const LoginTermsInformationScreen({
    Key? key,
    required this.email,
    required this.socialId,
    required this.isSocialKakao,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getLoginTermsInformationBinding();

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
            padding: EdgeInsets.only(left: 16.0.w,right: 16.0.w),
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
                        () => const LoginTermsOfServiceScreen(),
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
                        () => const LoginPrivacyPolicyScreen(),
                        transition: Transition.rightToLeft,
                      );
                    },
                    isAgree: controller.isPrivacyPolicyAgree.value,
                  ),
                ),
                // SizedBox(
                //   height: 16.h,
                // ),

              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w,vertical: 40.h),
            child: Obx(
                  () => TermButtons(
                title: '가입 완료하기',
                onTap: () async {
                  if (controller.isTermsAgree.value &&
                      controller.isPrivacyPolicyAgree.value) {
                    final result = await controller.signup(
                        socialId, email, isSocialKakao);
                    if (result) {
                      //회원가입이 성공하면 login

                      //로그인이
                      Get.offAll(
                            () => OnBoardingNicknameScreen(),
                      );
                    }
                  }
                },
                isAgree: controller.isTermsAgree.value &&
                    controller.isPrivacyPolicyAgree.value,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
