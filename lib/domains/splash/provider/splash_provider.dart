import 'package:dio/dio.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/domains/diary/provider/diary_provider.dart';
import 'package:frontend/domains/login/provider/login_provider.dart';
import 'package:frontend/domains/on_boarding/provider/on_boarding_provider.dart';
import 'package:frontend/domains/splash/model/splash_state.dart';
import 'package:frontend/domains/token/provider/token_provider.dart';
import 'package:frontend/main.dart';
import 'package:frontend/res/constants.dart';
import 'package:frontend/ui/components/dialog_button.dart';
import 'package:frontend/ui/components/dialog_component.dart';
import 'package:frontend/ui/screen/home/home_screen.dart';
import 'package:frontend/ui/screen/login/login_screen.dart';
import 'package:store_redirect/store_redirect.dart';

final splashProvider = StateNotifierProvider<SplashNotifier, SplashState>((ref) {
  return SplashNotifier(
    ref,
    ref.read(tokenProvider.notifier),
    ref.read(onBoardingProvider.notifier),
    ref.read(diaryProvider.notifier),
  );
});

class SplashNotifier extends StateNotifier<SplashState> {
  SplashNotifier(this.ref, this.tokenController, this.onBoardingController, this.diaryController) : super(SplashState()) {}

  final Ref ref;
  final TokenNotifier tokenController;
  final OnBoardingNotifier onBoardingController;
  final DiaryNotifier diaryController;

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

        usingServer = remoteConfig.getString("using_server");
        print("usingServer ${usingServer}");
        isBannerOpen = remoteConfig.getBool("is_christmas_banner_open");
        bannerUrl = remoteConfig.getString("banner_url");

        if (APP_BUILD_NUMBER < remoteConfig.getInt("min_build_number")) {
          state = state.copyWith(isNeedUpdate: true);

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
                        "lib/config/assets/images/character/haru_error_case.png",
                        width: 120.w,
                        height: 120.h,
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      Text(
                        "업데이트가 필요합니다.",
                        style: kHeader3Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Text(
                        "필수 업데이트를 해야만 앱을 이용할 수 있습니다.",
                        style: kHeader6Style.copyWith(color: Theme.of(context).colorScheme.textSubtitle),
                      ),
                    ],
                  ),
                  actionContent: [
                    DialogButton(
                      title: "업데이트",
                      onTap: () async {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                            (route) => false);

                        StoreRedirect.redirect(androidAppId: "com.beside04.haruNyang", iOSAppId: "6444657575");
                      },
                      backgroundColor: kOrange200Color,
                      textStyle: kHeader4Style.copyWith(color: kWhiteColor),
                    ),
                  ],
                ),
              );
            },
          );
        } else if (!state.isOpenPopup && APP_BUILD_NUMBER < remoteConfig.getInt("recommend_build_number")) {
          state = state.copyWith(isNeedUpdate: true);

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
                        style: kHeader3Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Text(
                        "업데이트하고 새로운 기능을 만나보세요.",
                        style: kHeader6Style.copyWith(color: Theme.of(context).colorScheme.textSubtitle),
                      ),
                    ],
                  ),
                  actionContent: [
                    DialogButton(
                      title: "다음에",
                      onTap: () async {
                        Navigator.pop(context);
                        String time = DateTime.now().toIso8601String();

                        state = state.copyWith(isOpenPopup: true);
                        await popUpUseCase.setLastPopUpDate(time);

                        goToHome();
                      },
                      backgroundColor: Theme.of(context).colorScheme.secondaryColor,
                      textStyle: kHeader4Style.copyWith(color: Theme.of(context).colorScheme.textSubtitle),
                    ),
                    SizedBox(
                      width: 12.w,
                    ),
                    DialogButton(
                      title: "업데이트",
                      onTap: () async {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                            (route) => false);

                        StoreRedirect.redirect(androidAppId: "com.beside04.haruNyang", iOSAppId: "6444657575");
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
    state = state.copyWith(lastPopupDate: await popUpUseCase.getLastPopUpDate());

    if (state.lastPopupDate != null) {
      DateTime now = DateTime.now();
      int timeDifference = now.difference(DateTime.parse(state.lastPopupDate!)).inDays;

      if (timeDifference < 30) state = state.copyWith(isOpenPopup: true);
    }
  }

  Future<void> init() async {
    await initUpdatePopup();
    await getLastDate();

    state.isNeedUpdate ? null : await goToHome();
  }

  Future<void> goToHome() async {
    int retryCount = 0;

    Future.delayed(const Duration(milliseconds: 1500), () async {
      String? accessToken = await tokenController.getAccessToken();

      if (accessToken == null) {
        //token이 없으면 로그인 화면 이동
        navigatorKey.currentState!.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
          (route) => false,
        );
      } else {
        if (retryCount < 1) {
          retryCount++;

          try {
            final getDeviceId = await tokenUseCase.getDeviceId();
            final getLoginType = await tokenUseCase.getLoginType();
            final getSocialId = await tokenUseCase.getSocialId();

            await ref.read(loginProvider.notifier).getLoginData();

            // ref.read(loginProvider.notifier).getLoginSuccessData(loginType: getLoginType!);

            navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);
          } on DioError catch (e) {
            // 로그인 화면으로 다시 이동
            // Get.snackbar('알림', '세션이 만료되었습니다.');
            await tokenUseCase.deleteAllToken();

            navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
          }
          // Your existing code here
        } else {
          // 로그인 화면으로 다시 이동
          // Get.snackbar('알림', '세션이 만료되었습니다.');
          await tokenUseCase.deleteAllToken();

          navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
        }
      }
    });
  }
}
