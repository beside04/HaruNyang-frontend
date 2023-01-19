import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/core/utils/utils.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/main_view_model.dart';
import 'package:frontend/presentation/components/dialog_button.dart';
import 'package:frontend/presentation/components/dialog_component.dart';
import 'package:frontend/presentation/home/home_view_model.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  final bool isFirstUser;

  const HomeScreen({
    super.key,
    this.isFirstUser = false,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeViewModel controller;

  @override
  void initState() {
    Get.delete<HomeViewModel>();
    controller = getHomeViewModelBinding();

    if (widget.isFirstUser) {
      //처음 가입한 유저라면 일기쓰기 화면으로 이동
      controller.selectedIndex.value = 1;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mainViewController = Get.find<MainViewModel>();

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
              final result = await controller.onItemTapped(index);
              if (!result) {
                showDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (context) {
                    return DialogComponent(
                      title: "알림",
                      content: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Text(
                          "일기는 하루에 한번만 작성 할 수 있어요.",
                          style: kHeader6Style.copyWith(
                              color:
                                  Theme.of(context).colorScheme.textSubtitle),
                        ),
                      ),
                      actionContent: [
                        DialogButton(
                          title: "확인",
                          onTap: () {
                            Get.back();
                          },
                          backgroundColor: Theme.of(context).primaryColor,
                          textStyle: kHeader4Style.copyWith(color: kWhiteColor),
                        ),
                      ],
                    );
                  },
                );
              }
            },
          ),
          body: controller.widgetList[controller.selectedIndex.value],
        ),
      ),
    );
  }
}
