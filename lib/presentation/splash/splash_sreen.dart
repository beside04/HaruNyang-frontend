import 'package:flutter/material.dart';
import 'package:frontend/common/layout/default_layout.dart';
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
    await Future.delayed(const Duration(milliseconds: 1500), () async {
      String? accessToken = await tokenController.getAccessToken();
      String? refreshToken = await tokenController.getRefreshToken();

      if (accessToken == null || refreshToken == null) {
        //token이 없으면 로그인 화면 이동
        Get.offAll(
          () => const LoginScreen(),
          binding: BindingsBuilder(
            getLoginBinding,
          ),
        );
      } else {
        //reissue token 실행
        final bool res = await onBoardingController.reissueToken(refreshToken);

        if (res) {
          //에러 없으면 user 정보 가져온다
          bool isOnBoardingDone = false;
          bool isError = false;
          final getMyInfoResult = await onBoardingController.getMyInformation();
          getMyInfoResult.when(
            success: (data) {
              isOnBoardingDone = data;
            },
            error: (message) {
              isError = true;
            },
          );

          if (!isError) {
            if (isOnBoardingDone == false) {
              //온보딩 화면 이동
              Get.offAll(
                () => const OnBoardingNicknameScreen(),
              );
            } else {
              //캘린더 업데이트
              diaryController.initPage();
              //북마크데이터 업데이트
              Get.find<DiaryController>().getAllBookmarkData();

              //Home 화면 이동
              Get.offAll(
                () => const HomeScreen(),
                binding: BindingsBuilder(
                  getHomeViewModelBinding,
                ),
              );
            }
          }
        } else {
          //에러 있으면 로그인 화면으로 이동
          Get.offAll(
            () => const LoginScreen(),
            binding: BindingsBuilder(
              getLoginBinding,
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
    return DefaultLayout(
      screenName: 'Screen_Event_Splash',
      child: Lottie.asset(
        'lib/config/assets/lottie/graphic_type2.json',
        controller: _controller,
        onLoaded: (composition) {
          _controller
            ..duration = composition.duration
            ..forward();
        },
        fit: BoxFit.fill,
      ),
    );
  }
}
