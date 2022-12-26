import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/main_view_model.dart';
import 'package:frontend/core/resource/firebase_options.dart';
import 'package:frontend/presentation/login/login_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
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
  await Get.find<MainViewModel>().getAccessToken();

  //FirebaseCrashlytics
  runZonedGuarded<Future<void>>(() async {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    initializeDateFormatting().then((_) => runApp(const MyApp()));
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}

class MyApp extends GetView<MainViewModel> {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (BuildContext context, Widget? child) {
        return GetMaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          getPages: [
            GetPage(name: '/home', page: () => const HomeScreen()),
          ],
          theme: ThemeData(
            scaffoldBackgroundColor: kWhiteColor,
            textSelectionTheme: const TextSelectionThemeData(
              cursorColor: kSuccessColor,
            ),
            primarySwatch: Colors.blue,
            inputDecorationTheme: const InputDecorationTheme(
              filled: true,
              fillColor: kGrayColor50,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: kGrayColor150),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: kGrayColor950),
              ),
            ),
          ),
          home: Get.find<MainViewModel>().token == null
              ? const LoginScreen()
              : const HomeScreen(),
          initialBinding: Get.find<MainViewModel>().token == null
              ? BindingsBuilder(
                  getLoginBinding,
                )
              : BindingsBuilder(
                  getHomeViewModelBinding,
                ),
        );
      },
    );
  }
}
