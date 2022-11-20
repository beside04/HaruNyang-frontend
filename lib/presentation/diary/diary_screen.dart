import 'package:flutter/material.dart';
import 'package:frontend/presentation/login/login_screen.dart';
import 'package:get/get.dart';

class DiaryScreen extends StatelessWidget {
  const DiaryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('다이어리'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('다이어리'),
            ElevatedButton(
              onPressed: () {
                Get.offAll(
                  const LoginScreen(),
                );
              },
              child: const Text('로그인 페이지로 이동'),
            ),
          ],
        ),
      ),
    );
  }
}
