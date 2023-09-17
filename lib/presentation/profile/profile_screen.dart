import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/global_controller/on_boarding/on_boarding_controller.dart';
import 'package:frontend/main_view_model.dart';
import 'package:frontend/presentation/profile/book_mark/book_mark_screen.dart';
import 'package:frontend/presentation/profile/components/profile_button.dart';
import 'package:frontend/presentation/profile/notice/notice_screen.dart';
import 'package:frontend/presentation/profile/profile_setting/profile_setting_screen.dart';
import 'package:frontend/res/constants.dart';
import 'package:get/get.dart';

import 'package:frontend/presentation/profile/terms/terms_screen.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/utils/utils.dart';
import 'push_message/push_message_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mainViewController = Get.find<MainViewModel>();
    final onBoardingController = Get.find<OnBoardingController>();

    return DefaultLayout(
      screenName: 'Screen_Event_Main_Profile',
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            children: [
              Container(
                color: Theme.of(context).colorScheme.backgroundColor,
                child: Padding(
                  padding: kPrimarySidePadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      Container(
                        width: 60.w,
                        height: 60.h,
                        decoration: BoxDecoration(
                          color: kOrange300Color,
                          shape: BoxShape.circle,
                          border: Border.all(width: 0.5, color: Colors.transparent),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(6.w),
                          child: Center(
                            child: Image.asset(
                              "lib/config/assets/images/character/character1.png",
                              width: 48.w,
                              height: 48.h,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      Obx(
                        () => Text(
                          '${onBoardingController.state.value.nickname}님 반가워요!',
                          style: kHeader2Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Obx(
                        () => Row(
                          children: [
                            onBoardingController.state.value.loginType == "KAKAO"
                                ? Container(
                                    width: 20.w,
                                    height: 20.h,
                                    decoration: const BoxDecoration(
                                      color: Color(0xffffe818),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: SvgPicture.asset(
                                            'lib/config/assets/images/login/kakao_logo.svg',
                                            width: 10.w,
                                            height: 10.h,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(
                                    width: 20.w,
                                    height: 20.h,
                                    decoration: const BoxDecoration(
                                      color: kBlackColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: SvgPicture.asset(
                                            'lib/config/assets/images/login/apple_logo.svg',
                                            width: 10.w,
                                            height: 10.h,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            Obx(
                              () => Text(
                                " ${onBoardingController.state.value.email}",
                                style: kBody3Style.copyWith(color: Theme.of(context).colorScheme.textSubtitle),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: kPrimarySidePadding,
                child: Divider(
                  thickness: 1.h,
                  height: 1.h,
                  color: Theme.of(context).colorScheme.border,
                ),
              ),
              ProfileButton(
                icon: SvgPicture.asset(
                  "lib/config/assets/images/profile/navigate_next.svg",
                ),
                title: '내 정보 관리',
                titleColor: Theme.of(context).colorScheme.textTitle,
                onPressed: () {
                  Get.to(
                    () => ProfileSettingScreen(
                      isKakaoLogin: onBoardingController.state.value.loginType == 'KAKAO',
                    ),
                    binding: BindingsBuilder(
                      getProfileSettingViewModelBinding,
                    ),
                  );
                },
              ),
              Divider(
                thickness: 12.h,
              ),
              ProfileButton(
                icon: SvgPicture.asset(
                  "lib/config/assets/images/profile/navigate_next.svg",
                ),
                title: '북마크 목록',
                titleColor: Theme.of(context).colorScheme.textTitle,
                onPressed: () {
                  Get.to(() => const BookMarkScreen());
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
                title: '푸시 메세지 설정',
                titleColor: Theme.of(context).colorScheme.textTitle,
                onPressed: () {
                  Get.to(() => const PushMessageScreen());
                },
              ),
              Divider(
                thickness: 1.h,
                height: 1.h,
                color: Theme.of(context).colorScheme.border,
              ),
              Obx(
                () => ProfileButton(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  icon: FlutterSwitch(
                    padding: 2,
                    width: 52.0.w,
                    height: 32.0.h,
                    activeColor: Theme.of(context).colorScheme.primaryColor,
                    inactiveColor: kGrayColor750,
                    toggleSize: 28.0.w,
                    value: mainViewController.themeMode.value == ThemeMode.light ||
                        (mainViewController.themeMode.value == ThemeMode.system && MediaQuery.of(context).platformBrightness == Brightness.light),
                    borderRadius: 50.0.w,
                    onToggle: (val) async {
                      mainViewController.toggleThemeMode(context);
                    },
                    activeIcon: Center(
                      child: SvgPicture.asset(
                        "lib/config/assets/images/profile/light_mode.svg",
                        width: 19.w,
                        height: 19.h,
                      ),
                    ),
                    inactiveIcon: Center(
                      child: SvgPicture.asset(
                        "lib/config/assets/images/profile/dark_mode.svg",
                        width: 14.w,
                        height: 18.h,
                      ),
                    ),
                  ),
                  title: '라이트 다크모드 전환',
                  titleColor: Theme.of(context).colorScheme.textTitle,
                  onPressed: null,
                ),
              ),
              Divider(
                thickness: 12.h,
              ),
              ProfileButton(
                icon: SvgPicture.asset(
                  "lib/config/assets/images/profile/navigate_next.svg",
                ),
                title: '공지사항',
                titleColor: Theme.of(context).colorScheme.textTitle,
                onPressed: () {
                  Get.to(() => const NoticeScreen());
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
                title: '이용약관',
                titleColor: Theme.of(context).colorScheme.textTitle,
                onPressed: () {
                  Get.to(
                    () => const TermsScreen(),
                  );
                },
              ),
              Divider(
                thickness: 12.h,
              ),
              ProfileButton(
                icon: SvgPicture.asset(
                  "lib/config/assets/images/profile/navigate_next.svg",
                ),
                title: '개발자 응원하기',
                titleColor: Theme.of(context).colorScheme.textTitle,
                onPressed: () async {
                  GlobalUtils.setAnalyticsCustomEvent('Click_CheerUp');
                  final InAppReview inAppReview = InAppReview.instance;

                  if (await inAppReview.isAvailable()) {
                    inAppReview.requestReview();
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
                title: '하루냥 인스타그램',
                titleColor: Theme.of(context).colorScheme.textTitle,
                onPressed: () async {
                  if (await canLaunch("instagram://user?username=haru__nyang__")) {
                    await launch("instagram://user?username=haru__nyang__");
                  } else if (await canLaunch("https://www.instagram.com/haru__nyang__/")) {
                    await launch("https://www.instagram.com/haru__nyang__/");
                  } else {
                    throw 'Could not launch Instagram';
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
                title: '1:1 문의하기',
                titleColor: Theme.of(context).colorScheme.textTitle,
                onPressed: () async {
                  if (!await launch("https://open.kakao.com/o/sDhHcgDf")) {
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
                icon: Text(
                  APP_VERSION_NUMBER,
                  style: kBody1Style.copyWith(
                    color: Theme.of(context).colorScheme.textSubtitle,
                  ),
                ),
                title: '앱 버전',
                titleColor: Theme.of(context).colorScheme.textTitle,
                onPressed: null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
