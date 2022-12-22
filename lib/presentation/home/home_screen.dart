import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/core/utils/utils.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/presentation/home/home_view_model.dart';
import 'package:get/get.dart';

class HomeScreen extends GetView<HomeViewModel> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    getHomeViewModelBinding();
    return WillPopScope(
      onWillPop: () async {
        bool backResult = GlobalUtils.onBackPressed();
        return await Future.value(backResult);
      },
      child: Obx(
        () => Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Column(
                  children: [
                    SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: SvgPicture.asset(
                        "lib/config/assets/images/home/light_mode/emotion_stamp.svg",
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                  ],
                ),
                label: '감정캘린더',
              ),
              BottomNavigationBarItem(
                icon: Column(
                  children: [
                    SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: SvgPicture.asset(
                        "lib/config/assets/images/home/light_mode/pen.svg",
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                  ],
                ),
                label: '일기쓰기',
              ),
              BottomNavigationBarItem(
                icon: Column(
                  children: [
                    SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: SvgPicture.asset(
                        "lib/config/assets/images/home/light_mode/profile.svg",
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                  ],
                ),
                label: '프로필',
              ),
            ],
            selectedLabelStyle: kBody2BlackStyle,
            unselectedLabelStyle: kBody2BlackStyle,
            currentIndex: controller.selectedIndex.value,
            unselectedItemColor: kBlackColor,
            selectedItemColor: kBlackColor,
            onTap: controller.onItemTapped,
          ),
          body: controller.widgetList[controller.selectedIndex.value],
        ),
      ),
    );
  }
}
