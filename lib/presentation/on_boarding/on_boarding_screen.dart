import 'package:flutter/material.dart';
import 'package:frontend/presentation/home/home_screen.dart';
import 'package:get/get.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('온보딩'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Get.offAll(
                  const HomeScreen(),
                );
              },
              child: const Text('홈화면 이동'),
            ),
          ],
        ),
      ),
    );
  }
}
