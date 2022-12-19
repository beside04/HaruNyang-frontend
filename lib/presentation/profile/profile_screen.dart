import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/presentation/profile/profile_setting/profile_setting_screen.dart';
import 'package:frontend/presentation/profile/profile_view_model.dart';
import 'package:get/get.dart';

class ProfileScreen extends GetView<ProfileViewModel> {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getProfileBinding();

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GetBuilder<ProfileViewModel>(builder: (controller) {
              return Padding(
                padding: kPrimarySidePadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50.h,
                    ),
                    Container(
                      width: 60.w,
                      height: 60.h,
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 0.5,
                          color: kGrayColor150,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Image.asset(
                              "lib/config/assets/images/on_boarding/test_img.png",
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      '${controller.nickname}집사, 반갑다냥.',
                      style: kHeader3BlackStyle,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      children: [
                        controller.loginType == "KAKAO"
                            ? Container(
                                width: 30.w,
                                height: 30.h,
                                decoration: const BoxDecoration(
                                  color: Color(0xffffe818),
                                  shape: BoxShape.circle,
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: SizedBox(
                                        width: 15.w,
                                        child: Image.asset(
                                          "lib/config/assets/images/login/kakao_logo.png",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                width: 30.w,
                                height: 30.h,
                                decoration: const BoxDecoration(
                                  color: kBlackColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: SizedBox(
                                        width: 30.w,
                                        child: Image.asset(
                                          "lib/config/assets/images/login/apple_logo.png",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        Text(
                          " email : ${controller.email}",
                          style: kSubtitle3BlackStyle,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                  ],
                ),
              );
            }),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 8.h,
              color: kGrayColor150,
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Get.to(() => const ProfileSettingScreen());
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 1, color: kGrayColor150),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 25.h),
                        child: Stack(
                          alignment: AlignmentDirectional.centerStart,
                          children: [
                            Text(
                              "내 정보 관리",
                              style: kSubtitle3BlackStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 1, color: kGrayColor150),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 25.h),
                        child: Stack(
                          alignment: AlignmentDirectional.centerStart,
                          children: [
                            Text(
                              "북마크 목록",
                              style: kSubtitle3BlackStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 1, color: kGrayColor150),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 25.h),
                        child: Stack(
                          alignment: AlignmentDirectional.centerStart,
                          children: [
                            Text(
                              "푸시메세지 설정",
                              style: kSubtitle3BlackStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 1, color: kGrayColor150),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 25.h),
                        child: Stack(
                          alignment: AlignmentDirectional.centerStart,
                          children: [
                            Text(
                              "라이트/다크모드 전환",
                              style: kSubtitle3BlackStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
