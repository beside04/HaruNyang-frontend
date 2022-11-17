import 'package:frontend/domain/use_case/kakao_login_use_case.dart';
import 'package:get/get.dart';

class LoginViewModel extends GetxController {
  final KakaoLoginUseCase kakaoLoginUseCase;

  LoginViewModel(this.kakaoLoginUseCase);

  Future<void> login() async {
    await kakaoLoginUseCase.login();
  }
}