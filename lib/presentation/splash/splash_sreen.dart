import 'package:flutter/material.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/global_controller/diary/diary_controller.dart';
import 'package:frontend/global_controller/on_boarding/on_boarding_controller.dart';
import 'package:frontend/global_controller/token/token_controller.dart';
import 'package:frontend/presentation/home/home_screen.dart';
import 'package:frontend/presentation/login/login_screen.dart';
import 'package:frontend/presentation/on_boarding/on_boarding_nickname/on_boarding_nickname_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final tokenController = Get.find<TokenController>();
  final onBoardingController = Get.find<OnBoardingController>();
  final diaryController = Get.find<DiaryController>();

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      init();
    });
    super.initState();
  }

  Future<void> init() async {
    await Future.delayed(const Duration(seconds: 5), () async {
      String? token = await tokenController.getAccessToken();
      bool isOnBoardingDone = false;
      if (token != null) {
        isOnBoardingDone = await onBoardingController.getMyInformation();
      }

      if (token == null) {
        //로그인 화면 이동
        Get.offAll(
          () => const LoginScreen(),
          binding: BindingsBuilder(
            getLoginBinding,
          ),
        );
      } else {
        //캘린더 업데이트
        diaryController.initPage();

        if (isOnBoardingDone == false) {
          //온보딩 화면 이동
          Get.offAll(
            () => const OnBoardingNicknameScreen(),
          );
        } else {
          //Home 화면 이동
          Get.find<DiaryController>().getAllBookmarkData();

          Get.offAll(
            () => const HomeScreen(),
            binding: BindingsBuilder(
              getHomeViewModelBinding,
            ),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'lib/config/assets/lottie/graphic_type.json',
      controller: _controller,
      onLoaded: (composition) {
        _controller
          ..duration = composition.duration
          ..forward();
      },
      fit: BoxFit.fill,
    );
  }
}
