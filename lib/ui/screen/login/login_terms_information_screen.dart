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
                                          ref.watch(loginTermsInformationProvider).isMarketingConsentAgree
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
                                          ref.watch(loginTermsInformationProvider).isMarketingConsentAgree
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
                      termOnTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => const TermsOfServiceScreen(isProfileScreen: false),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              const begin = Offset(0.0, 1.0);
                              const end = Offset.zero;
                              const curve = Curves.easeInOut;
                              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                              var offsetAnimation = animation.drive(tween);
                              return SlideTransition(position: offsetAnimation, child: child);
                            },
                          ),
                        );
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
                      termOnTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => const PrivacyPolicyScreen(isProfileScreen: false),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              const begin = Offset(0.0, 1.0);
                              const end = Offset.zero;
                              const curve = Curves.easeInOut;
                              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                              var offsetAnimation = animation.drive(tween);
                              return SlideTransition(position: offsetAnimation, child: child);
                            },
                          ),
                        );
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
                      termOnTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => const MarketingConsentScreen(isProfileScreen: false),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              const begin = Offset(0.0, 1.0);
                              const end = Offset.zero;
                              const curve = Curves.easeInOut;
                              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                              var offsetAnimation = animation.drive(tween);
                              return SlideTransition(position: offsetAnimation, child: child);
                            },
                          ),
                        );
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
                        ref.watch(loginTermsInformationProvider.notifier).goToLoginScreen("kakao");
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
