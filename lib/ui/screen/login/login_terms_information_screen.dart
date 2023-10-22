import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/domains/login/provider/login_terms_information_provider.dart';
import 'package:frontend/ui/components/back_icon.dart';
import 'package:frontend/ui/components/bottom_button.dart';
import 'package:frontend/ui/screen/login/components/term_check_box.dart';
import 'package:frontend/ui/screen/profile/terms/marketing_consent_screen.dart';
import 'package:frontend/ui/screen/profile/terms/privacy_policy_screen.dart';
import 'package:frontend/ui/screen/profile/terms/terms_of_service_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginTermsInformationScreen extends ConsumerWidget {
  final String loginType;

  const LoginTermsInformationScreen({
    Key? key,
    required this.loginType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      screenName: 'Screen_Event_Login_Terms',
      child: Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text(
              "약관동의",
              style: kHeader4Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
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
                      style: kBody3Style.copyWith(color: Theme.of(context).colorScheme.textSubtitle),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  GestureDetector(
                    onTap: ref.watch(loginTermsInformationProvider.notifier).toggleAllCheck,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Theme.of(context).colorScheme.brightness == Brightness.dark
                            ? Consumer(builder: (context, ref, child) {
                                return SizedBox(
                                  width: 24.w,
                                  height: 24.h,
                                  child: ref.watch(loginTermsInformationProvider).isTermsAgree &&
                                          ref.watch(loginTermsInformationProvider).isPrivacyPolicyAgree &&
                                          ref.watch(loginTermsInformationProvider).isMarketingConsentAgree &&
                                          ref.watch(loginTermsInformationProvider).isOverseasRelocationConsentAgree
                                      ? Image.asset(
                                          "lib/config/assets/images/check/round_check_primary.png",
                                        )
                                      : Image.asset(
                                          "lib/config/assets/images/check/round_check_dark_mode.png",
                                        ),
                                );
                              })
                            : Consumer(builder: (context, ref, child) {
                                return SizedBox(
                                  width: 24.w,
                                  height: 24.h,
                                  child: ref.watch(loginTermsInformationProvider).isTermsAgree &&
                                          ref.watch(loginTermsInformationProvider).isPrivacyPolicyAgree &&
                                          ref.watch(loginTermsInformationProvider).isMarketingConsentAgree &&
                                          ref.watch(loginTermsInformationProvider).isOverseasRelocationConsentAgree
                                      ? Image.asset(
                                          "lib/config/assets/images/check/round_check_primary.png",
                                        )
                                      : Image.asset(
                                          "lib/config/assets/images/check/round_check_light_mode.png",
                                        ),
                                );
                              }),
                        Padding(
                          padding: EdgeInsets.all(8.w),
                          child: Text(
                            '전체 동의하기',
                            style: kSubtitle1Style.copyWith(color: Theme.of(context).colorScheme.textBody),
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
                  Consumer(builder: (context, ref, child) {
                    return TermCheckBox(
                      termValue: ref.watch(loginTermsInformationProvider).isTermsAgree,
                      termTitle: Row(
                        children: [
                          Text(
                            '(필수) ',
                            style: kBody2Style.copyWith(color: Theme.of(context).colorScheme.textPrimary),
                          ),
                          Text(
                            '서비스 이용약관',
                            style: kBody2Style.copyWith(color: Theme.of(context).colorScheme.textBody),
                          ),
                        ],
                      ),
                      onTap: ref.watch(loginTermsInformationProvider.notifier).toggleTermsCheck,
                      termOnTap: () async {
                        if (!await launch("https://www.notion.so/e505f096785141e2b31c206ae439f4ee")) {
                          throw Exception('Could not launch');
                        }
                        // Get.to(
                        //   () => const TermsOfServiceScreen(
                        //     isProfileScreen: false,
                        //   ),
                        //   transition: Transition.downToUp,
                        // );
                      },
                    );
                  }),
                  SizedBox(
                    height: 16.h,
                  ),
                  Consumer(builder: (context, ref, child) {
                    return TermCheckBox(
                      termValue: ref.watch(loginTermsInformationProvider).isPrivacyPolicyAgree,
                      termTitle: Row(
                        children: [
                          Text(
                            '(필수) ',
                            style: kBody2Style.copyWith(color: Theme.of(context).colorScheme.textPrimary),
                          ),
                          Text(
                            '개인정보 처리방침',
                            style: kBody2Style.copyWith(color: Theme.of(context).colorScheme.textBody),
                          ),
                        ],
                      ),
                      onTap: ref.watch(loginTermsInformationProvider.notifier).togglePrivacyPolicyCheck,
                      termOnTap: () async {
                        if (!await launch("https://www.notion.so/25c01aca07c34481bd1b5b1d5c364499?pvs=4")) {
                          throw Exception('Could not launch');
                        }
                        // Get.to(
                        //   () => const PrivacyPolicyScreen(
                        //     isProfileScreen: false,
                        //   ),
                        //   transition: Transition.downToUp,
                        // );
                      },
                    );
                  }),
                  SizedBox(
                    height: 16.h,
                  ),
                  Consumer(builder: (context, ref, child) {
                    return TermCheckBox(
                      termValue: ref.watch(loginTermsInformationProvider).isOverseasRelocationConsentAgree,
                      termTitle: Row(
                        children: [
                          Text(
                            '(필수) ',
                            style: kBody2Style.copyWith(color: Theme.of(context).colorScheme.textPrimary),
                          ),
                          Text(
                            '개인정보 국외 이전 동의',
                            style: kBody2Style.copyWith(color: Theme.of(context).colorScheme.textBody),
                          ),
                        ],
                      ),
                      onTap: ref.watch(loginTermsInformationProvider.notifier).toggleOverseasRelocationConsent,
                      termOnTap: () async {
                        if (!await launch("https://www.notion.so/2c3190cd57db4605889a6f07eac92f3b")) {
                          throw Exception('Could not launch');
                        }
                        // Get.to(
                        //   () => const PrivacyPolicyScreen(
                        //     isProfileScreen: false,
                        //   ),
                        //   transition: Transition.downToUp,
                        // );
                      },
                    );
                  }),
                  SizedBox(
                    height: 16.h,
                  ),
                  Consumer(builder: (context, ref, child) {
                    return TermCheckBox(
                      termValue: ref.watch(loginTermsInformationProvider).isMarketingConsentAgree,
                      termTitle: Text(
                        '(선택) 마케팅 정보 수신 동의',
                        style: kBody2Style.copyWith(color: Theme.of(context).colorScheme.textBody),
                      ),
                      onTap: ref.watch(loginTermsInformationProvider.notifier).toggleMarketingConsentCheck,
                      termOnTap: () async {
                        if (!await launch("https://www.notion.so/39648dc746334206b5d353b93eee62bd")) {
                          throw Exception('Could not launch');
                        }
                        // Get.to(
                        //   () => const MarketingConsentScreen(
                        //     isProfileScreen: false,
                        //   ),
                        //   transition: Transition.downToUp,
                        // );
                      },
                    );
                  }),
                ],
              ),
            ),
            const Spacer(),
            Consumer(builder: (context, ref, child) {
              return BottomButton(
                title: "가입 완료하기",
                onTap: ref.watch(loginTermsInformationProvider).isTermsAgree && ref.watch(loginTermsInformationProvider).isPrivacyPolicyAgree
                    ? () {
                        ref.watch(loginTermsInformationProvider.notifier).goToLoginScreen(loginType);
                      }
                    : null,
              );
            }),
          ],
        ),
      ),
    );
  }
}
