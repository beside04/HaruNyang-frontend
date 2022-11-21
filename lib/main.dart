import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/presentation/login/login_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

void main() async {
  await dotenv.load(
    fileName: '.env', //default
  );
  // runApp() 호출 전 Flutter SDK 초기화
  String appkey = dotenv.env['NATIVE_APP_KEY'] ?? '';
  KakaoSdk.init(nativeAppKey: appkey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (BuildContext context, Widget? child) {
        return GetMaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            inputDecorationTheme: const InputDecorationTheme(
              filled: true,
              fillColor: kGrayColor50,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: kGrayColor150),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: kSuccessColor),
              ),
            ),
          ),
          home: const LoginScreen(),
          initialBinding: BindingsBuilder(getLoginBinding),
        );
      },
    );
  }
}
