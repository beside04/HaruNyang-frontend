import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/ui/components/back_icon.dart';
import 'package:frontend/ui/screen/profile/components/profile_button.dart';
import 'package:frontend/ui/screen/profile/terms/marketing_consent_screen.dart';
import 'package:frontend/ui/screen/profile/terms/privacy_policy_screen.dart';
import 'package:frontend/ui/screen/profile/terms/terms_of_service_screen.dart';

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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TermsOfServiceScreen(
                        isProfileScreen: true,
                      ),
                    ),
                  );
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PrivacyPolicyScreen(
                        isProfileScreen: true,
                      ),
                    ),
                  );
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MarketingConsentScreen(
                        isProfileScreen: true,
                      ),
                    ),
                  );
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
