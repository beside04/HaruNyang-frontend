import 'package:frontend/data/repository/token_repository_impl.dart';
import 'package:frontend/data/repository/social_login_repository/apple_login_impl.dart';
import 'package:frontend/data/repository/server_login_repository_impl.dart';
import 'package:frontend/data/repository/social_login_repository/kakao_login_impl.dart';
import 'package:frontend/domain/use_case/token_use_case.dart';
import 'package:frontend/domain/use_case/social_login_use_case/apple_login_use_case.dart';
import 'package:frontend/domain/use_case/social_login_use_case/kakao_login_use_case.dart';
import 'package:frontend/main_view_model.dart';
import 'package:frontend/presentation/diary/diary_view_model.dart';
import 'package:frontend/presentation/login/login_terms_information/login_terms_information_viewmodel.dart';
import 'package:frontend/presentation/login/login_view_model.dart';
import 'package:frontend/presentation/on_boarding/on_boarding_birth/on_boarding_birth_viewmodel.dart';
import 'package:frontend/presentation/on_boarding/on_boarding_job/on_boarding_job_viewmodel.dart';
import 'package:frontend/presentation/on_boarding/on_boarding_nickname/on_boarding_nickname_viewmodel.dart';
import 'package:get/get.dart';

final KakaoLoginImpl kakaoLoginImpl = KakaoLoginImpl();
final AppleLoginImpl appleLoginImpl = AppleLoginImpl();
final TokenRepositoryImpl tokenRepositoryImpl = TokenRepositoryImpl();
final ServerLoginRepositoryImpl serverLoginImpl = ServerLoginRepositoryImpl();

//use case
final KakaoLoginUseCase kakaoLoginUseCase = KakaoLoginUseCase(
  socialLoginRepository: kakaoLoginImpl,
  serverLoginRepository: serverLoginImpl,
  tokenRepository: tokenRepositoryImpl,
);

final AppleLoginUseCase appleLoginUseCase = AppleLoginUseCase(
  socialLoginRepository: appleLoginImpl,
  serverLoginRepository: serverLoginImpl,
  tokenRepository: tokenRepositoryImpl,
);

final TokenUseCase tokenUseCase = TokenUseCase(
  tokenRepository: TokenRepositoryImpl(),
);

void getLoginBinding() {
  Get.put(LoginViewModel(
    kakaoLoginUseCase: kakaoLoginUseCase,
    appleLoginUseCase: appleLoginUseCase,
  ));
  Get.put(MainViewModel(
    tokenUseCase: tokenUseCase,
  ));
}

void getDiaryBinding() {
  Get.put(DiaryViewModel(
    kakaoLoginUseCase: kakaoLoginUseCase,
  ));
}

void getLoginTermsInformationBinding() {
  Get.put(LoginTermsInformationViewModel(
    kakaoLoginUseCase: kakaoLoginUseCase,
    appleLoginUseCase: appleLoginUseCase,
  ));
}

void getOnBoardingJobBinding() {
  Get.put(OnBoardingJobViewModel());
}

void getOnBoardingBirthBinding() {
  Get.put(OnBoardingBirthViewModel());
}

void getOnBoardingNickNameBinding() {
  Get.put(OnBoardingNicknameViewModel());
}
