import 'package:frontend/domain/use_case/social_login_use_case/apple_login_use_case.dart';
import 'package:frontend/domain/use_case/social_login_use_case/kakao_login_use_case.dart';
import 'package:get/get.dart';

class LoginTermsInformationViewModel extends GetxController {
  final KakaoLoginUseCase kakaoLoginUseCase;
  final AppleLoginUseCase appleLoginUseCase;

  LoginTermsInformationViewModel({
    required this.kakaoLoginUseCase,
    required this.appleLoginUseCase,
  });

  final RxBool isTermsAgree = false.obs;
  final RxBool isPrivacyPolicyAgree = false.obs;
}
