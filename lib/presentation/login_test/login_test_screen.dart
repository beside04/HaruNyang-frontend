import 'package:flutter/material.dart';
import 'package:frontend/presentation/login_test/login_test_view_model.dart';
import 'package:get/get.dart';

class LoginTestScreen extends GetView<LoginViewModel> {
  const LoginTestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await controller.login();
              },
              child: const Text('로그인 테스트'),
            ),
          ],
        ),
      ),
    );
  }
}
