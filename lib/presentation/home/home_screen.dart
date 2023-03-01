import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/core/utils/utils.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/main_view_model.dart';
import 'package:frontend/presentation/components/toast.dart';
import 'package:frontend/presentation/home/home_view_model.dart';
import 'package:get/get.dart';

class HomeScreen extends GetView<HomeViewModel> {
  final bool isFirstUser;

  const HomeScreen({
    super.key,
    this.isFirstUser = false,
  });

  @override
  Widget build(BuildContext context) {
    getHomeViewModelBinding();

    if (isFirstUser) {
      //처음 가입한 유저라면 일기쓰기 화면으로 이동
      controller.selectedIndex.value = 1;
    }

    final mainViewController = Get.find<MainViewModel>();

    return WillPopScope(
      onWillPop: () async {
        bool backResult = GlobalUtils.onBackPressed();
        return await Future.value(backResult);
      },
      child: Obx(
        () => Scaffold(
          bottomNavigationBar: controller.selectedIndex.value == 1
              ? null
              : MediaQuery(
                  data: MediaQueryData(padding: EdgeInsets.only(bottom: 0.h)),
                  child: Container(
                    padding: GetPlatform.isAndroid
                        ? EdgeInsets.only(bottom: 10.h)
                        : EdgeInsets.only(bottom: 30.h),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border(
                        top: BorderSide(
                          color: Theme.of(context).colorScheme.border,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: BottomNavigationBar(
                      elevation: 0,
                      items: [
                        BottomNavigationBarItem(
                          icon: controller.selectedIndex.value == 0
                              ? mainViewController.isDarkMode.value
                                  ? SvgPicture.asset(
                                      "lib/config/assets/images/home/dark_mode/tap_emotion_stamp.svg",
                                    )
                                  : SvgPicture.asset(
                                      "lib/config/assets/images/home/light_mode/tap_emotion_stamp.svg",
                                    )
                              : mainViewController.isDarkMode.value
                                  ? SvgPicture.asset(
                                      "lib/config/assets/images/home/dark_mode/emotion_stamp.svg",
                                    )
                                  : SvgPicture.asset(
                                      "lib/config/assets/images/home/light_mode/emotion_stamp.svg",
                                    ),
                          label: '감정캘린더',
                        ),
                        BottomNavigationBarItem(
                          icon: controller.selectedIndex.value == 1
                              ? mainViewController.isDarkMode.value
                                  ? SvgPicture.asset(
                                      "lib/config/assets/images/home/dark_mode/tap_pen.svg",
                                    )
                                  : SvgPicture.asset(
                                      "lib/config/assets/images/home/light_mode/tap_pen.svg",
                                    )
                              : mainViewController.isDarkMode.value
                                  ? SvgPicture.asset(
                                      "lib/config/assets/images/home/dark_mode/pen.svg",
                                    )
                                  : SvgPicture.asset(
                                      "lib/config/assets/images/home/light_mode/pen.svg",
                                    ),
                          label: '일기쓰기',
                        ),
                        BottomNavigationBarItem(
                          icon: controller.selectedIndex.value == 2
                              ? mainViewController.isDarkMode.value
                                  ? SvgPicture.asset(
                                      "lib/config/assets/images/home/dark_mode/tap_profile.svg",
                                    )
                                  : SvgPicture.asset(
                                      "lib/config/assets/images/home/light_mode/tap_profile.svg",
                                    )
                              : mainViewController.isDarkMode.value
                                  ? SvgPicture.asset(
                                      "lib/config/assets/images/home/dark_mode/profile.svg",
                                    )
                                  : SvgPicture.asset(
                                      "lib/config/assets/images/home/light_mode/profile.svg",
                                    ),
                          label: '프로필',
                        ),
                      ],
                      currentIndex: controller.selectedIndex.value,
                      onTap: (index) async {
                        getHomeViewModelBinding();
                        final result = await controller.onItemTapped(index);

                        if (!result) {
                          // ignore: use_build_context_synchronously
                          toast(
                            context: context,
                            text: '일기는 하루에 한번만 작성 할 수 있어요.',
                            isCheckIcon: false,
                          );
                        }
                      },
                    ),
                  ),
                ),
          body: controller.widgetList[controller.selectedIndex.value],
        ),
      ),
    );
  }
}
