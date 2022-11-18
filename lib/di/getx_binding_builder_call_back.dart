import 'package:frontend/data/repository/kakao_login_impl.dart';
import 'package:frontend/domain/use_case/kakao_login_use_case.dart';
import 'package:frontend/presentation/login_test/login_test_view_model.dart';
import 'package:get/get.dart';

final KakaoLoginImpl kakaoLoginImpl = KakaoLoginImpl();

//use case
final KakaoLoginUseCase kakaoLoginUseCase = KakaoLoginUseCase(
  repository: kakaoLoginImpl,
);

void getLoginBinding() {
  Get.put(LoginViewModel(kakaoLoginUseCase));
}
