import 'package:flutter/material.dart';
import 'package:frontend/presentation/on_boarding/on_boarding_screen.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Get.offAll(
                  const OnBoardingScreen(),
                );
              },
              child: const Text('로그인(온보딩 이동)'),
            ),
          ],
        ),
      ),
    );
  }
}
