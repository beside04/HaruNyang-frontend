import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/presentation/components/back_icon.dart';
import 'package:frontend/presentation/profile/components/profile_button.dart';
import 'package:frontend/presentation/profile/terms/marketing_consent_screen.dart';
import 'package:frontend/presentation/profile/terms/privacy_policy_screen.dart';
import 'package:frontend/presentation/profile/terms/terms_of_service_screen.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      screenName: 'Screen_Event_Profile_Terms',
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '이용약관',
            style: kHeader4Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
          ),
          elevation: 0,
          leading: BackIcon(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
          child: ListView(
            children: [
              Divider(
                thickness: 12.h,
              ),
              ProfileButton(
                icon: SvgPicture.asset(
                  "lib/config/assets/images/profile/navigate_next.svg",
                ),
                title: '서비스 이용약관',
                titleColor: Theme.of(context).colorScheme.textTitle,
                onPressed: () async {
                  if (!await launch("https://www.notion.so/e505f096785141e2b31c206ae439f4ee")) {
                    throw Exception('Could not launch');
                  }
                  // Get.to(
                  //   () => const TermsOfServiceScreen(
                  //     isProfileScreen: true,
                  //   ),
                  // );
                },
              ),
              Divider(
                thickness: 1.h,
                height: 1.h,
                color: Theme.of(context).colorScheme.border,
              ),
              ProfileButton(
                icon: SvgPicture.asset(
                  "lib/config/assets/images/profile/navigate_next.svg",
                ),
                title: '개인정보 처리방침',
                titleColor: Theme.of(context).colorScheme.textTitle,
                onPressed: () async {
                  if (!await launch("https://www.notion.so/25c01aca07c34481bd1b5b1d5c364499?pvs=4")) {
                    throw Exception('Could not launch');
                  }

                  // Get.to(
                  //   () => const PrivacyPolicyScreen(
                  //     isProfileScreen: true,
                  //   ),
                  // );
                },
              ),
              Divider(
                thickness: 1.h,
                height: 1.h,
                color: Theme.of(context).colorScheme.border,
              ),
              ProfileButton(
                icon: SvgPicture.asset(
                  "lib/config/assets/images/profile/navigate_next.svg",
                ),
                title: '개인정보 국외 이전 동의',
                titleColor: Theme.of(context).colorScheme.textTitle,
                onPressed: () async {
                  if (!await launch("https://www.notion.so/2c3190cd57db4605889a6f07eac92f3b")) {
                    throw Exception('Could not launch');
                  }
                },
              ),
              Divider(
                thickness: 1.h,
                height: 1.h,
                color: Theme.of(context).colorScheme.border,
              ),
              ProfileButton(
                icon: SvgPicture.asset(
                  "lib/config/assets/images/profile/navigate_next.svg",
                ),
                title: '마케팅 정보 수신 동의',
                titleColor: Theme.of(context).colorScheme.textTitle,
                onPressed: () async {
                  if (!await launch("https://www.notion.so/39648dc746334206b5d353b93eee62bd")) {
                    throw Exception('Could not launch');
                  }
                  // Get.to(
                  //   () => const MarketingConsentScreen(
                  //     isProfileScreen: true,
                  //   ),
                  // );
                },
              ),
              Divider(
                thickness: 1.h,
                height: 1.h,
                color: Theme.of(context).colorScheme.border,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
