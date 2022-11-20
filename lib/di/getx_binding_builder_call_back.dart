import 'package:frontend/data/repository/access_token_repository_impl.dart';
import 'package:frontend/data/repository/kakao_login_impl.dart';
import 'package:frontend/data/repository/server_login_repository_impl.dart';
import 'package:frontend/domain/use_case/access_token_use_case.dart';
import 'package:frontend/domain/use_case/kakao_login_use_case.dart';
import 'package:frontend/presentation/diary/diary_view_model.dart';
import 'package:frontend/presentation/login/login_view_model.dart';
import 'package:get/get.dart';

final KakaoLoginImpl kakaoLoginImpl = KakaoLoginImpl();
final ServerLoginRepositoryImpl serverLoginImpl = ServerLoginRepositoryImpl();

//use case
final KakaoLoginUseCase kakaoLoginUseCase = KakaoLoginUseCase(
  socialLoginRepository: kakaoLoginImpl,
  serverLoginRepository: serverLoginImpl,
);

final AccessTokenUseCase accessTokenUseCase = AccessTokenUseCase(
  accessTokenRepository: AccessTokenRepositoryImpl(),
);

void getLoginBinding() {
  Get.put(LoginViewModel(
    kakaoLoginUseCase: kakaoLoginUseCase,
    accessTokenUseCase: accessTokenUseCase,
  ));
}

void getDiaryBinding() {
  Get.put(DiaryViewModel(
    kakaoLoginUseCase: kakaoLoginUseCase,
  ));
}
