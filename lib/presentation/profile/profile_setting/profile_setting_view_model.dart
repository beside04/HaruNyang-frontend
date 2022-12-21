import 'package:frontend/domain/use_case/social_login_use_case/apple_login_use_case.dart';
import 'package:frontend/domain/use_case/social_login_use_case/kakao_login_use_case.dart';
import 'package:get/get.dart';

class ProfileSettingViewModel extends GetxController {
  final KakaoLoginUseCase kakaoLoginUseCase;
  final AppleLoginUseCase appleLoginUseCase;

  ProfileSettingViewModel({
    required this.kakaoLoginUseCase,
    required this.appleLoginUseCase,
  });

  Future<void> kakaoLogout() async {
    await kakaoLoginUseCase.logout();
  }

  Future<void> appleLogout() async {
    await appleLoginUseCase.logout();
  }
}
