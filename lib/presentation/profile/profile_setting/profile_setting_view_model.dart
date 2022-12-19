import 'package:frontend/domain/use_case/social_login_use_case/kakao_login_use_case.dart';
import 'package:get/get.dart';

class ProfileSettingViewModel extends GetxController {
  final KakaoLoginUseCase kakaoLoginUseCase;

  ProfileSettingViewModel({
    required this.kakaoLoginUseCase,
  });

  Future<void> logout() async {
    await kakaoLoginUseCase.logout();
  }
}
