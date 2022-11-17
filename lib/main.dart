import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/presentation/login/login_screen.dart';
import 'package:get/get.dart';

void main() {
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
              filled: true, //<-- SEE HERE
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
        );
      },
    );
  }
}
