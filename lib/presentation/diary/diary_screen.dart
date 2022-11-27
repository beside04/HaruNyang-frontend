import 'package:flutter/material.dart';
import 'package:frontend/data/data_source/remote_data/login_api.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/presentation/diary/diary_view_model.dart';
import 'package:frontend/presentation/login/login_screen.dart';
import 'package:frontend/presentation/on_boarding/on_boarding_nickname/on_boarding_nickname_screen.dart';
import 'package:get/get.dart';

class DiaryScreen extends GetView<DiaryViewModel> {
  const DiaryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getDiaryBinding();
    return Scaffold(
      appBar: AppBar(
        title: const Text('다이어리'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('다이어리'),
            ElevatedButton(
              onPressed: () async {
                await Get.find<DiaryViewModel>().logout();
                Get.offAll(
                  const LoginScreen(),
                );
              },
              child: const Text('로그아웃'),
            ),
            ElevatedButton(
              onPressed: () async {
                final LoginApi loginApi = LoginApi();

                await loginApi.getMyInformation();
              },
              child: const Text('test'),
            ),
            ElevatedButton(
              onPressed: () async {
                final LoginApi loginApi = LoginApi();

                await loginApi.getMyInformation();
                Get.to(
                  () => OnBoardingNicknameScreen(
                    socialId: "1234",
                  ),
                );
              },
              child: const Text('온보딩 수정하기(테스트)'),
            ),
          ],
        ),
      ),
    );
  }
}
