import 'package:frontend/domain/use_case/push_message/push_message_use_case.dart';
import 'package:frontend/domain/use_case/social_login_use_case/apple_login_use_case.dart';
import 'package:frontend/domain/use_case/social_login_use_case/kakao_login_use_case.dart';
import 'package:frontend/presentation/login/login_screen.dart';
import 'package:get/get.dart';

class LoginTermsInformationViewModel extends GetxController {
  final KakaoLoginUseCase kakaoLoginUseCase;
  final AppleLoginUseCase appleLoginUseCase;
  final PushMessageUseCase pushMessagePermissionUseCase;

  LoginTermsInformationViewModel({
    required this.kakaoLoginUseCase,
    required this.appleLoginUseCase,
    required this.pushMessagePermissionUseCase,
  });

  final RxBool isAllCheckAgree = false.obs;
  final RxBool isTermsAgree = false.obs;
  final RxBool isPrivacyPolicyAgree = false.obs;
  final RxBool isMarketingConsentAgree = false.obs;

  void toggleAllCheck() {
    isAllCheckAgree.value = !isAllCheckAgree.value;
    if (isAllCheckAgree.value) {
      isTermsAgree.value = true;
      isPrivacyPolicyAgree.value = true;
      isMarketingConsentAgree.value = true;
      pushMessagePermissionUseCase.setMarketingConsentAgree(true.toString());
    } else {
      isTermsAgree.value = false;
      isPrivacyPolicyAgree.value = false;
      isMarketingConsentAgree.value = false;
      pushMessagePermissionUseCase.setMarketingConsentAgree(false.toString());
    }
  }

  void toggleTermsCheck() {
    isTermsAgree.value = !isTermsAgree.value;
  }

  void togglePrivacyPolicyCheck() {
    isPrivacyPolicyAgree.value = !isPrivacyPolicyAgree.value;
  }

  void toggleMarketingConsentCheck() {
    if (isMarketingConsentAgree.value) {
      isMarketingConsentAgree.value = false;
      pushMessagePermissionUseCase.setMarketingConsentAgree(false.toString());
    } else {
      isMarketingConsentAgree.value = true;
      pushMessagePermissionUseCase.setMarketingConsentAgree(true.toString());
    }
  }

  void goToLoginScreen(bool isSocialKakao) {
    Get.offAll(
      () => LoginScreen(
        isSignup: true,
        isSocialKakao: isSocialKakao,
      ),
    );
  }
}
