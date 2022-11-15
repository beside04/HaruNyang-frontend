import 'package:flutter/material.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/presentation/login/login_screen.dart';
import 'package:frontend/presentation/login_test/login_test_screen.dart';
import 'package:frontend/presentation/login_test/login_test_view_model.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

void main() {
  // runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(nativeAppKey: '9259b7d6cf61cfa59dd4c396a97bd2a4');
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
