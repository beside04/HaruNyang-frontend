import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/main_view_model.dart';
import 'package:frontend/presentation/components/back_icon.dart';
import 'package:frontend/presentation/components/bottom_button.dart';
import 'package:frontend/presentation/login/components/term_check_box.dart';
import 'package:frontend/presentation/login/login_terms_information/login_terms_information_viewmodel.dart';
import 'package:frontend/presentation/profile/terms/marketing_consent_screen.dart';
import 'package:frontend/presentation/profile/terms/privacy_policy_screen.dart';
import 'package:frontend/presentation/profile/terms/terms_of_service_screen.dart';
import 'package:get/get.dart';

class LoginTermsInformationScreen
    extends GetView<LoginTermsInformationViewModel> {
  final bool isSocialKakao;

  const LoginTermsInformationScreen({
    Key? key,
    required this.isSocialKakao,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getLoginTermsInformationBinding();

    return DefaultLayout(
      screenName: 'Screen_Event_Login_Terms',
      child: Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text(
              "약관동의",
              style: kHeader4Style.copyWith(
                  color: Theme.of(context).colorScheme.textTitle),
            ),
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: Container(
                color: Theme.of(context).colorScheme.border,
                height: 1.0,
              ),
            ),
            leading: BackIcon(
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: kPrimarySidePadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 32.h,
                  ),
                  Container(
                    padding: kPrimaryPadding,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface_01,
                      borderRadius: BorderRadius.circular(12.0.w),
                    ),
                    child: Text(
                      '하루냥의 서비스 약관이에요. \n 필수 약관을 동의하셔야 이용할 수 있어요',
                      style: kBody3Style.copyWith(
                          color: Theme.of(context).colorScheme.textSubtitle),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  GestureDetector(
                    onTap: controller.toggleAllCheck,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Theme.of(context).colorScheme.brightness ==
                                Brightness.dark
                            ? Obx(
                                () => SizedBox(
                                  width: 24.w,
                                  height: 24.h,
                                  child: controller.isTermsAgree.value &&
                                          controller
                                              .isPrivacyPolicyAgree.value &&
                                          controller
                                              .isMarketingConsentAgree.value
                                      ? Image.asset(
                                          "lib/config/assets/images/check/round_check_primary.png",
                                        )
                                      : Image.asset(
                                          "lib/config/assets/images/check/round_check_dark_mode.png",
                                        ),
                                ),
                              )
                            : Obx(
                                () => SizedBox(
                                  width: 24.w,
                                  height: 24.h,
                                  child: controller.isTermsAgree.value &&
                                          controller
                                              .isPrivacyPolicyAgree.value &&
                                          controller
                                              .isMarketingConsentAgree.value
                                      ? Image.asset(
                                          "lib/config/assets/images/check/round_check_primary.png",
                                        )
                                      : Image.asset(
                                          "lib/config/assets/images/check/round_check_light_mode.png",
                                        ),
                                ),
                              ),
                        Padding(
                          padding: EdgeInsets.all(8.w),
                          child: Text(
                            '전체 동의하기',
                            style: kSubtitle1Style.copyWith(
                                color: Theme.of(context).colorScheme.textBody),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Divider(
                      thickness: 1.h,
                    ),
                  ),
                  Obx(
                    () => TermCheckBox(
                      termValue: controller.isTermsAgree.value,
                      termTitle: Row(
                        children: [
                          Text(
                            '(필수) ',
                            style: kBody2Style.copyWith(
                                color:
                                    Theme.of(context).colorScheme.textPrimary),
                          ),
                          Text(
                            '서비스 이용약관',
                            style: kBody2Style.copyWith(
                                color: Theme.of(context).colorScheme.textBody),
                          ),
                        ],
                      ),
                      onTap: controller.toggleTermsCheck,
                      termOnTap: () {
                        Get.to(
                          () => const TermsOfServiceScreen(
                            isProfileScreen: false,
                          ),
                          transition: Transition.downToUp,
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Obx(
                    () => TermCheckBox(
                      termValue: controller.isPrivacyPolicyAgree.value,
                      termTitle: Row(
                        children: [
                          Text(
                            '(필수) ',
                            style: kBody2Style.copyWith(
                                color:
                                    Theme.of(context).colorScheme.textPrimary),
                          ),
                          Text(
                            '개인정보 처리방침',
                            style: kBody2Style.copyWith(
                                color: Theme.of(context).colorScheme.textBody),
                          ),
                        ],
                      ),
                      onTap: controller.togglePrivacyPolicyCheck,
                      termOnTap: () {
                        Get.to(
                          () => const PrivacyPolicyScreen(
                            isProfileScreen: false,
                          ),
                          transition: Transition.downToUp,
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Obx(
                    () => TermCheckBox(
                      termValue: controller.isMarketingConsentAgree.value,
                      termTitle: Text(
                        '(선택) 마케팅 정보 수신 동의',
                        style: kBody2Style.copyWith(
                            color: Theme.of(context).colorScheme.textBody),
                      ),
                      onTap: controller.toggleMarketingConsentCheck,
                      termOnTap: () {
                        Get.to(
                          () => const MarketingConsentScreen(
                            isProfileScreen: false,
                          ),
                          transition: Transition.downToUp,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Obx(
              () => BottomButton(
                title: "가입 완료하기",
                onTap: controller.isTermsAgree.value &&
                        controller.isPrivacyPolicyAgree.value
                    ? () {
                        controller.goToLoginScreen(isSocialKakao);
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
