import 'package:frontend/domain/use_case/social_login_use_case/kakao_login_use_case.dart';
import 'package:get/get.dart';

class LoginTermsInformationViewModel extends GetxController {
  final KakaoLoginUseCase kakaoLoginUseCase;

  LoginTermsInformationViewModel({
    required this.kakaoLoginUseCase,
  });

  final RxBool isTermsAgree = false.obs;
  final RxBool isPrivacyPolicyAgree = false.obs;

  Future<bool> signup(String socialId, String email) async {
    final result = await kakaoLoginUseCase.signup(email, socialId);
    if (!result) {
      Get.snackbar('알림', '회원가입에 실패했습니다.');
    }
    return result;
  }
}
