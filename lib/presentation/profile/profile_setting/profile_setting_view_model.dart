import 'package:flutter/material.dart';
import 'package:frontend/domain/use_case/on_boarding_use_case/on_boarding_use_case.dart';
import 'package:frontend/domain/use_case/social_login_use_case/apple_login_use_case.dart';
import 'package:frontend/domain/use_case/social_login_use_case/kakao_login_use_case.dart';
import 'package:frontend/res/constants.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProfileSettingViewModel extends GetxController {
  final KakaoLoginUseCase kakaoLoginUseCase;
  final AppleLoginUseCase appleLoginUseCase;
  final OnBoardingUseCase onBoardingUseCase;

  ProfileSettingViewModel({
    required this.kakaoLoginUseCase,
    required this.appleLoginUseCase,
    required this.onBoardingUseCase,
  });

  final TextEditingController nicknameEditingController =
      TextEditingController();
  final RxString nicknameValue = ''.obs;
  final TextEditingController ageEditingController = TextEditingController();
  final RxString ageValue = ''.obs;
  final Rx<Job?> jobStatus = Rx<Job?>(null);

  @override
  void onInit() {
    super.onInit();
    nicknameEditingController.addListener(() {
      nicknameValue.value = nicknameEditingController.text;
    });

    ageEditingController.addListener(() {
      ageValue.value = ageEditingController.text;
    });
  }

  @override
  void onClose() {
    nicknameEditingController.dispose();
    ageEditingController.dispose();
    super.onClose();
  }

  void getBirthDateFormat(date) {
    ageEditingController.text = DateFormat('yyyy-MM-dd').format(date);
  }

  Future<void> kakaoLogout() async {
    await kakaoLoginUseCase.logout();
  }

  Future<void> appleLogout() async {
    await appleLoginUseCase.logout();
  }

  Future<void> putMyInformation({
    required nickname,
    required job,
    required age,
  }) async {
    onBoardingUseCase.putMyInformation(nickname: nickname, job: job, age: age);
  }
}
