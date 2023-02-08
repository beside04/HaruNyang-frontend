import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/main_view_model.dart';
import 'package:frontend/core/resource/firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/presentation/splash/splash_sreen.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'presentation/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load();

  // runApp() 호출 전 Flutter SDK 초기화
  String appkey = dotenv.env['NATIVE_APP_KEY'] ?? '';
  KakaoSdk.init(nativeAppKey: appkey);
  getMainBinding();
  globalControllerBinding();
  await Get.find<MainViewModel>().getIsDarkMode();
  await Get.find<MainViewModel>().getIsPushMessage();

  //FirebaseCrashlytics
  runZonedGuarded<Future<void>>(() async {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    initializeDateFormatting().then((_) => runApp(const MyApp()));
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}

void globalControllerBinding() {
  getDiaryBinding();
  getDiaryControllerBinding();
  getOnBoardingControllerBinding();
  getTokenControllerBinding();
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends GetView<MainViewModel> {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MainViewModel>();
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (BuildContext context, Widget? child) {
        return Obx(
          () => AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent, // 투명색
              systemNavigationBarColor:
                  controller.isDarkMode.value ? kGrayColor950 : kBeigeColor100,
              systemNavigationBarIconBrightness: controller.isDarkMode.value
                  ? Brightness.light
                  : Brightness.dark,
              systemNavigationBarDividerColor:
                  controller.isDarkMode.value ? kGrayColor950 : kBeigeColor100,
            ),
            child: GetMaterialApp(
              title: 'Flutter Demo',
              debugShowCheckedModeBanner: false,
              initialRoute: '/',
              getPages: [
                GetPage(name: '/', page: () => const SplashScreen()),
                GetPage(name: '/home', page: () => const HomeScreen()),
              ],
              themeMode: controller.isDarkMode.value
                  ? ThemeMode.dark
                  : ThemeMode.light,
              theme: lightMode(context),
              darkTheme: darkMode(context),
              home: const SplashScreen(),
            ),
          ),
        );
      },
    );
  }
}
