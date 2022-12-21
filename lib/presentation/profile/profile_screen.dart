import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/presentation/profile/components/profile_button.dart';
import 'package:frontend/presentation/profile/profile_setting/profile_setting_screen.dart';
import 'package:frontend/presentation/profile/profile_view_model.dart';
import 'package:get/get.dart';

class ProfileScreen extends GetView<ProfileViewModel> {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getProfileBinding();
    controller.getMyInformation();
    final state = controller.state;

    return Scaffold(
      backgroundColor: const Color(0xffedebe8),
      body: SafeArea(
        child: ListView(
          children: [
            GetBuilder<ProfileViewModel>(builder: (controller) {
              return Container(
                color: kWhiteColor,
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
                          color: kPrimary2Color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 0.5,
                            color: kGrayColor150,
                          ),
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
                          '${state.value.nickname}님 반가워요!',
                          style: kHeader2BlackStyle,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Obx(
                        () => Row(
                          children: [
                            state.value.loginType == "KAKAO"
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
                                          child: Image.asset(
                                            "lib/config/assets/images/login/kakao_logo.png",
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
                                          child: Image.asset(
                                            "lib/config/assets/images/login/apple_logo.png",
                                            width: 10.w,
                                            height: 10.h,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            Obx(
                              () => Text(
                                " ${state.value.email}",
                                style: kBody2Gray400Style,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  ),
                ),
              );
            }),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 1.h,
              color: kGrayColor100,
            ),
            ProfileButton(
              icon: const Icon(
                Icons.navigate_next,
                color: kGrayColor250,
              ),
              title: '내 정보 관리',
              onPressed: () {
                Get.to(
                  () => ProfileSettingScreen(
                    isKakaoLogin: state.value.loginType == 'KAKAO',
                  ),
                  binding: BindingsBuilder(
                    getProfileSettingViewModelBinding,
                  ),
                );
              },
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 12.h,
              color: const Color(0xffedebe8),
            ),
            const ProfileButton(
              icon: Icon(
                Icons.navigate_next,
                color: kGrayColor250,
              ),
              title: '북마크 목록',
              onPressed: null,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 1.h,
              color: kGrayColor100,
            ),
            Obx(
              () => ProfileButton(
                icon: FlutterSwitch(
                  width: 52.0.w,
                  height: 32.0.h,
                  activeColor: kPrimary2Color,
                  inactiveColor: kGrayColor250,
                  toggleSize: 28.0.w,
                  value: controller.pushMessageValue.value,
                  borderRadius: 50.0.w,
                  onToggle: (val) async {
                    controller.togglePushMessageValue();
                  },
                ),
                title: '푸시 메세지 설정',
                onPressed: null,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 1.h,
              color: kGrayColor100,
            ),
            Obx(
              () => ProfileButton(
                icon: FlutterSwitch(
                  width: 52.0.w,
                  height: 32.0.h,
                  activeColor: kPrimary2Color,
                  inactiveColor: kGrayColor250,
                  toggleSize: 28.0.w,
                  value: controller.lightModeValue.value,
                  borderRadius: 50.0.w,
                  onToggle: (val) async {
                    controller.toggleLightModeValue();
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
            Container(
              width: MediaQuery.of(context).size.width,
              height: 12.h,
              color: const Color(0xffedebe8),
            ),
            const ProfileButton(
              icon: Icon(
                Icons.navigate_next,
                color: kGrayColor250,
              ),
              title: '공지사항',
              onPressed: null,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 12.h,
              color: const Color(0xffedebe8),
            ),
            const ProfileButton(
              icon: Icon(
                Icons.navigate_next,
                color: kGrayColor250,
              ),
              title: '이용약관',
              onPressed: null,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 1.h,
              color: kGrayColor100,
            ),
            const ProfileButton(
              icon: Icon(
                Icons.navigate_next,
                color: kGrayColor250,
              ),
              title: '개인정보 취급방침',
              onPressed: null,
            ),
          ],
        ),
      ),
    );
  }
}
