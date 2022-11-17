import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/presentation/login_test/login_test_screen.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

void main() async {
  await dotenv.load(
    fileName: '.env', //default
  );
  // runApp() 호출 전 Flutter SDK 초기화
  String appkey = dotenv.env['NATIVE_APP_KEY'] ?? '';
  print(appkey);
  KakaoSdk.init(nativeAppKey: appkey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginTestScreen(),
      initialBinding: BindingsBuilder(getLoginBinding),
    );
  }
}
