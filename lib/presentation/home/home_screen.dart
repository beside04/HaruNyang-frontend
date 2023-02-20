import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/core/utils/utils.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/main.dart';
import 'package:frontend/main_view_model.dart';
import 'package:frontend/presentation/components/dialog_button.dart';
import 'package:frontend/presentation/components/dialog_component.dart';
import 'package:frontend/presentation/components/toast.dart';
import 'package:frontend/presentation/home/home_view_model.dart';
import 'package:frontend/presentation/login/login_screen.dart';
import 'package:frontend/res/constants.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

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

    initUpdatePopup();

    super.initState();
  }

  void initUpdatePopup() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetchAndActivate();
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 1),
      minimumFetchInterval: const Duration(seconds: 1),
    ));

    if (APP_BUILD_NUMBER < remoteConfig.getInt("min_build_number")) {
      showDialog(
        barrierDismissible: false,
        context: navigatorKey.currentContext!,
        builder: (context) {
          return DialogComponent(
            title: "업데이트가 필요합니다.",
            content: Text(
              "필수 업데이트를 해야만 앱을 이용할 수 있습니다.",
              style: kHeader6Style.copyWith(
                  color: Theme.of(context).colorScheme.textSubtitle),
            ),
            actionContent: [
              DialogButton(
                title: "업데이트",
                onTap: () async {
                  Get.offAll(() => const LoginScreen());

                  GetPlatform.isAndroid
                      ? await launchUrl(
                          Uri.parse(
                              "https://play.google.com/store/apps/details?id=com.beside04.haruNyang"),
                        )
                      : await launchUrl(
                          Uri.parse("https://apps.apple.com/app/id6444657575"),
                        );
                },
                backgroundColor: kOrange200Color,
                textStyle: kHeader4Style.copyWith(color: kWhiteColor),
              ),
            ],
          );
        },
      );
    } else if (APP_BUILD_NUMBER <
        remoteConfig.getInt("recommend_build_number")) {
      showDialog(
        barrierDismissible: true,
        context: navigatorKey.currentContext!,
        builder: (context) {
          return DialogComponent(
            title: "새로운 버전이 있습니다.",
            content: Text(
              "업데이트 하고 새로운 기능을 만나보세요.",
              style: kHeader6Style.copyWith(
                  color: Theme.of(context).colorScheme.textSubtitle),
            ),
            actionContent: [
              DialogButton(
                title: "다음에",
                onTap: () async {
                  Get.back();
                },
                backgroundColor: Theme.of(context).colorScheme.secondaryColor,
                textStyle: kHeader4Style.copyWith(
                    color: Theme.of(context).colorScheme.textSubtitle),
              ),
              SizedBox(
                width: 12.w,
              ),
              DialogButton(
                title: "업데이트",
                onTap: () async {
                  Get.offAll(() => const LoginScreen());
                  GetPlatform.isAndroid
                      ? await launchUrl(
                          Uri.parse(
                              "https://play.google.com/store/apps/details?id=com.beside04.haruNyang"),
                        )
                      : await launchUrl(
                          Uri.parse("https://apps.apple.com/app/id6444657575"),
                        );
                },
                backgroundColor: kOrange200Color,
                textStyle: kHeader4Style.copyWith(color: kWhiteColor),
              ),
            ],
          );
        },
      );
    }
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
