import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/data/data_source/global_service.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/domain/use_case/emotion_stamp_use_case/get_emotion_diary_use_case.dart';
import 'package:frontend/domain/use_case/pop_up/pop_up_use_case.dart';
import 'package:frontend/global_controller/diary/diary_controller.dart';
import 'package:frontend/global_controller/on_boarding/on_boarding_controller.dart';
import 'package:frontend/global_controller/token/token_controller.dart';
import 'package:frontend/main.dart';
import 'package:frontend/presentation/birth_day/birth_day_screen.dart';
import 'package:frontend/presentation/components/dialog_button.dart';
import 'package:frontend/presentation/components/dialog_component.dart';
import 'package:frontend/presentation/diary/diary_screen.dart';
import 'package:frontend/presentation/emotion_stamp/emotion_stamp_screen.dart';
import 'package:frontend/presentation/home/home_screen.dart';
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
  RxBool isNeedUpdate = false.obs;

  final tokenController = Get.find<TokenController>();
  final onBoardingController = Get.find<OnBoardingController>();
  final diaryController = Get.find<DiaryController>();

  final globalService = Get.find<GlobalService>();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      init();
    });
  }

  Future<void> initUpdatePopup() async {
    const int maxRetries = 3;
    int currentRetries = 0;

    final remoteConfig = FirebaseRemoteConfig.instance;

    while (currentRetries < maxRetries) {
      try {
        await remoteConfig.fetchAndActivate();
        await remoteConfig.setConfigSettings(RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 1),
          minimumFetchInterval: const Duration(seconds: 1),
        ));

        globalService.usingServer.value =
            remoteConfig.getString("using_server");

        if (APP_BUILD_NUMBER < remoteConfig.getInt("min_build_number")) {
          isNeedUpdate.value = true;
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
          isNeedUpdate.value = true;

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

                        goToHome();
                      },
                      backgroundColor:
                          Theme.of(context).colorScheme.secondaryColor,
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

        break; // 데이터를 성공적으로 가져왔으므로 반복문을 종료합니다.
      } catch (e) {
        currentRetries++; // 재시도 횟수를 증가시킵니다.
        if (currentRetries == maxRetries) {
          print("Remote Config 데이터를 가져오는 데 실패했습니다: $e");
        } else {
          print("재시도 중... ($currentRetries/$maxRetries)");
          await Future.delayed(Duration(seconds: 2)); // 2초 동안 기다립니다.
        }
      }
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

  Future<void> init() async {
    await initUpdatePopup();
    await getLastDate();

    isNeedUpdate.value ? null : await goToHome();
  }

  Future<void> goToHome() async {
    Future.delayed(const Duration(milliseconds: 1500), () async {
      String? accessToken = await tokenController.getAccessToken();

      if (accessToken == null) {
        //token이 없으면 로그인 화면 이동
        Get.offAll(
          () => const LoginScreen(),
          binding: BindingsBuilder(
            getLoginBinding,
          ),
        );
      } else {
        //캘린더 업데이트
        diaryController.initPage();
        //북마크데이터 업데이트
        Get.find<DiaryController>().getAllBookmarkData();

        //Home 화면 이동

        await Get.find<OnBoardingController>().getMyInformation();

        Get.offAll(
          () => const HomeScreen(),
          binding: BindingsBuilder(
            getHomeViewModelBinding,
          ),
        );
      }
    });
  }
}
