import 'package:flutter/material.dart';
import 'package:frontend/domain/use_case/social_login_use_case/kakao_login_use_case.dart';
import 'package:frontend/presentation/diary/components/emotion_modal.dart';
import 'package:frontend/presentation/diary/components/weather_modal.dart';
import 'package:frontend/res/constants.dart';
import 'package:get/get.dart';

class DiaryViewModel extends GetxController
    with GetSingleTickerProviderStateMixin {
  final KakaoLoginUseCase kakaoLoginUseCase;
  late AnimationController animationController;

  DiaryViewModel({
    required this.kakaoLoginUseCase,
  });

  final weatherStatus = Rx<Weather?>(null);
  final emotionStatus = Rx<Emotion?>(null);
  final nowDate = DateTime.now().obs;
  final numberValue = 2.0.obs;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  List<Widget> stackChildren = <Widget>[
    const EmotionModal(),
    const WeatherModal(),
  ];

  void swapStackChildren() {
    stackChildren = [
      const WeatherModal(),
      const EmotionModal(),
    ];
    update();
  }

  void swapStackChildren2() {
    stackChildren = [
      const EmotionModal(),
      const WeatherModal(),
    ];
    update();
  }

  Future<void> logout() async {
    await kakaoLoginUseCase.logout();
  }
}
