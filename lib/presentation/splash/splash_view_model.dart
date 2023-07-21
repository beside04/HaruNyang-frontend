import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/domain/use_case/emotion_stamp_use_case/get_emotion_diary_use_case.dart';
import 'package:frontend/domain/use_case/pop_up/pop_up_use_case.dart';
import 'package:frontend/global_controller/on_boarding/on_boarding_controller.dart';
import 'package:frontend/main.dart';
import 'package:frontend/presentation/birth_day/birth_day_screen.dart';
import 'package:frontend/presentation/components/dialog_button.dart';
import 'package:frontend/presentation/components/dialog_component.dart';
import 'package:frontend/presentation/diary/diary_screen.dart';
import 'package:frontend/presentation/emotion_stamp/emotion_stamp_screen.dart';
import 'package:frontend/presentation/login/login_screen.dart';
import 'package:frontend/presentation/profile/profile_screen.dart';
import 'package:frontend/res/constants.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:store_redirect/store_redirect.dart';

import '../../core/utils/utils.dart';

class SplashViewModel extends GetxController {
  final PopUpUseCase popUpUseCase;

  SplashViewModel({
    required this.popUpUseCase,
  });

  RxInt selectedIndex = 0.obs;
  RxBool isOpenPopup = false.obs;

  String? lastPopupDate;
  String? lastBirthDayPopupDate;

  @override
  void onInit() {
    super.onInit();

    initUpdatePopup();

    getLastDate();
  }

  void initUpdatePopup() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetchAndActivate();
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 1),
      minimumFetchInterval: const Duration(seconds: 1),
    ));

    String usingServer = "";

    usingServer = remoteConfig.getString("using_server");

    print(usingServer);
    print(usingServer);
    print(usingServer);
    print(usingServer);

    if (APP_BUILD_NUMBER < remoteConfig.getInt("min_build_number")) {
      showDialog(
        barrierDismissible: false,
        context: navigatorKey.currentContext!,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: DialogComponent(
              titlePadding: EdgeInsets.zero,
              title: "",
              content: Column(
                children: [
                  Image.asset(
                    "lib/config/assets/images/character/update1.png",
                    width: 120.w,
                    height: 120.h,
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Text(
                    "업데이트가 필요합니다.",
                    style: kHeader3Style.copyWith(
                        color: Theme.of(context).colorScheme.textTitle),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Text(
                    "필수 업데이트를 해야만 앱을 이용할 수 있습니다.",
                    style: kHeader6Style.copyWith(
                        color: Theme.of(context).colorScheme.textSubtitle),
                  ),
                ],
              ),
              actionContent: [
                DialogButton(
                  title: "업데이트",
                  onTap: () async {
                    Get.offAll(() => const LoginScreen());

                    StoreRedirect.redirect(
                        androidAppId: "com.beside04.haruNyang",
                        iOSAppId: "6444657575");
                  },
                  backgroundColor: kOrange200Color,
                  textStyle: kHeader4Style.copyWith(color: kWhiteColor),
                ),
              ],
            ),
          );
        },
      );
    } else if (!isOpenPopup.value &&
        APP_BUILD_NUMBER < remoteConfig.getInt("recommend_build_number")) {
      showDialog(
        barrierDismissible: false,
        context: navigatorKey.currentContext!,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: DialogComponent(
              titlePadding: EdgeInsets.zero,
              title: "",
              content: Column(
                children: [
                  Image.asset(
                    "lib/config/assets/images/character/update2.png",
                    width: 120.w,
                    height: 120.h,
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Text(
                    "새로운 버전이 있습니다.",
                    style: kHeader3Style.copyWith(
                        color: Theme.of(context).colorScheme.textTitle),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Text(
                    "업데이트하고 새로운 기능을 만나보세요.",
                    style: kHeader6Style.copyWith(
                        color: Theme.of(context).colorScheme.textSubtitle),
                  ),
                ],
              ),
              actionContent: [
                DialogButton(
                  title: "다음에",
                  onTap: () async {
                    Navigator.pop(context);
                    String time = DateTime.now().toIso8601String();
                    isOpenPopup.value = true;
                    await popUpUseCase.setLastPopUpDate(time);
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
                    StoreRedirect.redirect(
                        androidAppId: "com.beside04.haruNyang",
                        iOSAppId: "6444657575");
                  },
                  backgroundColor: kOrange200Color,
                  textStyle: kHeader4Style.copyWith(color: kWhiteColor),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  getLastDate() async {
    lastPopupDate = await popUpUseCase.getLastPopUpDate();

    if (lastPopupDate != null) {
      DateTime now = DateTime.now();
      int timeDifference =
          now.difference(DateTime.parse(lastPopupDate!)).inDays;

      if (timeDifference < 30) isOpenPopup.value = true;
    }
  }
}
