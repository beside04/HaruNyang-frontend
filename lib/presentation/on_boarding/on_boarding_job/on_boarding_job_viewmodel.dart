import 'package:frontend/domain/use_case/access_token_use_case.dart';
import 'package:frontend/domain/use_case/kakao_login_use_case.dart';
import 'package:frontend/presentation/home/home_screen.dart';
import 'package:frontend/res/constants.dart';
import 'package:get/get.dart';

class OnBoardingJobViewModel extends GetxController {
  final KakaoLoginUseCase kakaoLoginUseCase;
  final AccessTokenUseCase accessTokenUseCase;

  OnBoardingJobViewModel({
    required this.kakaoLoginUseCase,
    required this.accessTokenUseCase,
  });

  final Rx<Job> jobStatus = Job.student.obs;
  final List jobList = ["학생", "취준생", "직장인", "프리랜서", "기타"].obs;

  Future<void> login(String socialId) async {
    final loginResult = await kakaoLoginUseCase.login(socialId);
    await loginResult.when(
      success: (accessToken) async {
        await accessTokenUseCase.setAccessToken(accessToken);
        Get.offAll(
          const HomeScreen(),
          transition: Transition.cupertino,
        );
      },
      error: (message) {
        Get.snackbar('알림', '로그인이 실패했습니다.');
      },
    );
  }
}
