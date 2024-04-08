import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/core/utils/utils.dart';
import 'package:frontend/domains/font/provider/font_provider.dart';
import 'package:frontend/domains/main/provider/main_provider.dart';
import 'package:frontend/domains/on_boarding/provider/on_boarding_provider.dart';
import 'package:frontend/res/constants.dart';
import 'package:frontend/ui/components/bottom_button.dart';
import 'package:frontend/ui/screen/profile/book_mark/book_mark_screen.dart';
import 'package:frontend/ui/screen/profile/components/profile_button.dart';
import 'package:frontend/ui/screen/profile/font_change/font_change_screen.dart';
import 'package:frontend/ui/screen/profile/notice/notice_screen.dart';
import 'package:frontend/ui/screen/profile/profile_setting/profile_setting_screen.dart';
import 'package:frontend/ui/screen/profile/terms/terms_screen.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';

import 'push_message/push_message_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                      Consumer(builder: (context, ref, child) {
                        return Text(
                          '${ref.watch(onBoardingProvider).nickname}님 반가워요!',
                          style: kHeader2Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                        );
                      }),
                      SizedBox(
                        height: 10.h,
                      ),
                      Consumer(builder: (context, ref, child) {
                        return Row(
                          children: [
                            ref.watch(onBoardingProvider).loginType == "KAKAO"
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
                            Consumer(builder: (context, ref, child) {
                              return Text(
                                " ${ref.watch(onBoardingProvider).email}",
                                style: kBody3Style.copyWith(color: Theme.of(context).colorScheme.textSubtitle),
                              );
                            }),
                          ],
                        );
                      }),
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
                  color: Theme.of(context).colorScheme.iconSubColor,
                ),
                title: '내 정보 관리',
                titleColor: Theme.of(context).colorScheme.textTitle,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileSettingScreen(
                        isKakaoLogin: ref.watch(onBoardingProvider).loginType == 'KAKAO',
                      ),
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
                  color: Theme.of(context).colorScheme.iconSubColor,
                ),
                title: '편지 보관함',
                titleColor: Theme.of(context).colorScheme.textTitle,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookMarkScreen(),
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
                  color: Theme.of(context).colorScheme.iconSubColor,
                ),
                title: '푸시 메세지 설정',
                titleColor: Theme.of(context).colorScheme.textTitle,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PushMessageScreen(),
                    ),
                  );
                },
              ),
              Divider(
                thickness: 1.h,
                height: 1.h,
                color: Theme.of(context).colorScheme.border,
              ),
              Consumer(builder: (context, ref, child) {
                return InkWell(
                  onTap: () {
                    ref.watch(mainProvider.notifier).tempThemeMode = ref.watch(mainProvider).themeMode;

                    showModalBottomSheet(
                      backgroundColor: Theme.of(context).colorScheme.backgroundModal,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(25.0),
                        ),
                      ),
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => StatefulBuilder(builder: (context, StateSetter setState) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Consumer(builder: (context, ref, child) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 32.0,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 24.0.w),
                                  child: Text(
                                    "기본 테마를 설정해주세요.",
                                    style: kHeader4Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                InkWell(
                                  onTap: () {
                                    ref.watch(mainProvider.notifier).tempThemeMode = ThemeMode.system;
                                    setState(() {});
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 19, horizontal: 24),
                                        child: Text(
                                          "시스템 설정",
                                          style: kHeader6Style.copyWith(
                                              color: ref.watch(mainProvider.notifier).tempThemeMode == ThemeMode.system
                                                  ? Theme.of(context).colorScheme.primaryColor
                                                  : Theme.of(context).colorScheme.textLowEmphasis),
                                        ),
                                      ),
                                      Visibility(
                                        visible: ref.watch(mainProvider.notifier).tempThemeMode == ThemeMode.system,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 19, horizontal: 24),
                                          child: Image.asset(
                                            "lib/config/assets/images/check/primary_color_check_bold.png",
                                            width: 17,
                                            height: 12,
                                            color: kOrange300Color,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    ref.watch(mainProvider.notifier).tempThemeMode = ThemeMode.light;
                                    setState(() {});
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 19, horizontal: 24),
                                        child: Text(
                                          "라이트 모드",
                                          style: kHeader6Style.copyWith(
                                              color: ref.watch(mainProvider.notifier).tempThemeMode == ThemeMode.light
                                                  ? Theme.of(context).colorScheme.primaryColor
                                                  : Theme.of(context).colorScheme.textLowEmphasis),
                                        ),
                                      ),
                                      Visibility(
                                        visible: ref.watch(mainProvider.notifier).tempThemeMode == ThemeMode.light,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 19, horizontal: 24),
                                          child: Image.asset(
                                            "lib/config/assets/images/check/primary_color_check_bold.png",
                                            width: 17,
                                            height: 12,
                                            color: kOrange300Color,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    ref.watch(mainProvider.notifier).tempThemeMode = ThemeMode.dark;
                                    setState(() {});
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 19, horizontal: 24),
                                        child: Text(
                                          "다크 모드",
                                          style: kHeader6Style.copyWith(
                                              color: ref.watch(mainProvider.notifier).tempThemeMode == ThemeMode.dark
                                                  ? Theme.of(context).colorScheme.primaryColor
                                                  : Theme.of(context).colorScheme.textLowEmphasis),
                                        ),
                                      ),
                                      Visibility(
                                        visible: ref.watch(mainProvider.notifier).tempThemeMode == ThemeMode.dark,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 19, horizontal: 24),
                                          child: Image.asset(
                                            "lib/config/assets/images/check/primary_color_check_bold.png",
                                            width: 17,
                                            height: 12,
                                            color: kOrange300Color,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                BottomButton(
                                  title: '변경하기',
                                  onTap: () {
                                    ref.watch(mainProvider.notifier).toggleThemeMode();
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          }),
                        );
                      }),
                    );
                  },
                  child: Container(
                    color: Theme.of(context).colorScheme.backgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Text(
                                "${'기본 테마 설정'}   ",
                                style: kHeader5Style.copyWith(
                                  color: Theme.of(context).colorScheme.textTitle,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            ref.watch(mainProvider.notifier).themeModeToString(ref.watch(mainProvider).themeMode),
                            style: kBody2Style.copyWith(color: Theme.of(context).colorScheme.textSubtitle),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          SvgPicture.asset(
                            "lib/config/assets/images/profile/navigate_next.svg",
                            color: Theme.of(context).colorScheme.iconSubColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              Divider(
                thickness: 1.h,
                height: 1.h,
                color: Theme.of(context).colorScheme.border,
              ),
              Consumer(builder: (context, ref, child) {
                return ProfileButton(
                  icon: Row(
                    children: [
                      Text(
                        ref.watch(fontProvider).selectedFontTitle,
                        style: kBody2Style.copyWith(color: Theme.of(context).colorScheme.textSubtitle),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SvgPicture.asset(
                        "lib/config/assets/images/profile/navigate_next.svg",
                        color: Theme.of(context).colorScheme.iconSubColor,
                      ),
                    ],
                  ),
                  title: '폰트 변경',
                  titleColor: Theme.of(context).colorScheme.textTitle,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FontChangeScreen(),
                      ),
                    );
                  },
                );
              }),
              Divider(
                thickness: 12.h,
              ),
              ProfileButton(
                icon: SvgPicture.asset(
                  "lib/config/assets/images/profile/navigate_next.svg",
                  color: Theme.of(context).colorScheme.iconSubColor,
                ),
                title: '공지사항',
                titleColor: Theme.of(context).colorScheme.textTitle,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NoticeScreen()),
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
                  color: Theme.of(context).colorScheme.iconSubColor,
                ),
                title: '이용약관',
                titleColor: Theme.of(context).colorScheme.textTitle,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TermsScreen()),
                  );
                },
              ),
              Divider(
                thickness: 12.h,
              ),
              ProfileButton(
                icon: SvgPicture.asset(
                  "lib/config/assets/images/profile/navigate_next.svg",
                  color: Theme.of(context).colorScheme.iconSubColor,
                ),
                title: '개발자 응원하기',
                titleColor: Theme.of(context).colorScheme.textTitle,
                onPressed: () async {
                  GlobalUtils.setAnalyticsCustomEvent('Click_CheerUp');
                  final InAppReview inAppReview = InAppReview.instance;
                  if (await inAppReview.isAvailable()) {
                    inAppReview.requestReview();
                  } else {
                    inAppReview.openStoreListing(appStoreId: '6444657575');
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
                  color: Theme.of(context).colorScheme.iconSubColor,
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
                  color: Theme.of(context).colorScheme.iconSubColor,
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
