import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/main_view_model.dart';
import 'package:frontend/presentation/profile/book_mark/book_mark_screen.dart';
import 'package:frontend/presentation/profile/components/profile_button.dart';
import 'package:frontend/presentation/profile/notice/notice_screen.dart';
import 'package:frontend/presentation/profile/profile_setting/profile_setting_screen.dart';
import 'package:frontend/presentation/profile/profile_view_model.dart';
import 'package:frontend/presentation/profile/terms/privacy_policy_screen.dart';
import 'package:frontend/presentation/profile/terms/terms_of_service_screen.dart';
import 'package:get/get.dart';

class ProfileScreen extends GetView<ProfileViewModel> {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getProfileBinding();
    final mainViewController = Get.find<MainViewModel>();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
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
                      color: kPrimary2Color,
                      shape: BoxShape.circle,
                      border: Border.all(width: 0.5, color: Colors.transparent),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10.0.w),
                      child: Center(
                        child: SvgPicture.asset(
                          "lib/config/assets/images/character/onboarding1.svg",
                          width: 40.w,
                          height: 40.h,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Obx(
                    () => Text(
                      '${Get.find<MainViewModel>().state.value.nickname}님 반가워요!',
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Obx(
                    () => Row(
                      children: [
                        Get.find<MainViewModel>().state.value.loginType ==
                                "KAKAO"
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
                                  //color: kBlackColor,
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
                            " ${Get.find<MainViewModel>().state.value.email}",
                            style: kBody2Gray400Style,
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
            ProfileButton(
              icon: const Icon(
                Icons.navigate_next,
                //color: kGrayColor250,
              ),
              title: '내 정보 관리',
              onPressed: () {
                Get.to(
                  () => ProfileSettingScreen(
                    isKakaoLogin:
                        Get.find<MainViewModel>().state.value.loginType ==
                            'KAKAO',
                  ),
                  binding: BindingsBuilder(
                    getProfileSettingViewModelBinding,
                  ),
                );
              },
            ),
            Divider(
              thickness: 12.h,
              color: Theme.of(context).colorScheme.darkTheme_100_700,
            ),
            ProfileButton(
              icon: const Icon(
                Icons.navigate_next,
              ),
              title: '북마크 목록',
              onPressed: () {
                Get.to(() => const BookMarkScreen());
              },
            ),
            Obx(
              () => ProfileButton(
                icon: FlutterSwitch(
                  width: 52.0.w,
                  height: 32.0.h,
                  activeColor: Theme.of(context).primaryColor,
                  inactiveColor: kGrayColor250,
                  toggleSize: 28.0.w,
                  value: mainViewController.pushMessageValue.value,
                  borderRadius: 50.0.w,
                  onToggle: (val) async {
                    mainViewController.togglePushMessageValue();
                  },
                ),
                title: '푸시 메세지 설정',
                onPressed: null,
              ),
            ),
            Obx(
              () => ProfileButton(
                icon: FlutterSwitch(
                  width: 52.0.w,
                  height: 32.0.h,
                  activeColor: Theme.of(context).primaryColor,
                  inactiveColor: kGrayColor250,
                  toggleSize: 28.0.w,
                  value: !mainViewController.isDarkMode.value,
                  borderRadius: 50.0.w,
                  onToggle: (val) async {
                    mainViewController.toggleTheme();
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
                onPressed: null,
              ),
            ),
            Divider(
              thickness: 12.h,
              color: Theme.of(context).colorScheme.darkTheme_100_700,
            ),
            ProfileButton(
              icon: const Icon(
                Icons.navigate_next,
                // color: kGrayColor250,
              ),
              title: '공지사항',
              onPressed: () {
                Get.to(() => const NoticeScreen());
              },
            ),
            Divider(
              thickness: 12.h,
              color: Theme.of(context).colorScheme.darkTheme_100_700,
            ),
            ProfileButton(
              icon: const Icon(
                Icons.navigate_next,
                // color: kGrayColor250,
              ),
              title: '서비스 이용약관',
              onPressed: () {
                Get.to(
                  () => const TermsOfServiceScreen(),
                  transition: Transition.downToUp,
                );
              },
            ),
            ProfileButton(
              icon: const Icon(
                Icons.navigate_next,
                // color: kGrayColor250,
              ),
              title: '개인정보 취급방침',
              onPressed: () {
                Get.to(
                  () => const PrivacyPolicyScreen(),
                  transition: Transition.downToUp,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
