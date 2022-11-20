import 'package:frontend/domain/use_case/kakao_login_use_case.dart';
import 'package:get/get.dart';

class DiaryViewModel extends GetxController {
  final KakaoLoginUseCase kakaoLoginUseCase;

  DiaryViewModel({
    required this.kakaoLoginUseCase,
  });



  Future<void> logout() async {
    await kakaoLoginUseCase.logout();
  }
}
