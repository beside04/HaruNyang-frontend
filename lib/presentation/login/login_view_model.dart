import 'package:frontend/domain/use_case/access_token_use_case.dart';
import 'package:frontend/domain/use_case/kakao_login_use_case.dart';
import 'package:frontend/presentation/home/home_screen.dart';
import 'package:frontend/presentation/login/login_terms_information/login_terms_information_screen.dart';
import 'package:get/get.dart';

class LoginViewModel extends GetxController {
  final KakaoLoginUseCase kakaoLoginUseCase;
  final AccessTokenUseCase accessTokenUseCase;

  LoginViewModel({
    required this.kakaoLoginUseCase,
    required this.accessTokenUseCase,
  });

  Future<void> login() async {
    final result = await kakaoLoginUseCase.login();
    result.when(
      success: (loginResult) async {
        //access token 저장
        await accessTokenUseCase.setAccessToken(loginResult.accessToken);

        if (loginResult.isSignup) {
          //이제 회원가입한 회원, 이용약관 페이지로 이동
          Get.to(const LoginTermsInformationScreen());
        } else {
          //원래 회원, 홈 화면으로 이동
          Get.offAll(const HomeScreen());
        }
      },
      error: (message) {
        Get.snackbar(
          '알림',
          'Login 실패 : $message',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }
}
