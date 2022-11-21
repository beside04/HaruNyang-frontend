import 'package:frontend/data/repository/access_token_repository_impl.dart';
import 'package:frontend/data/repository/kakao_login_impl.dart';
import 'package:frontend/data/repository/server_login_repository_impl.dart';
import 'package:frontend/domain/use_case/access_token_use_case.dart';
import 'package:frontend/domain/use_case/kakao_login_use_case.dart';
import 'package:frontend/presentation/diary/diary_view_model.dart';
import 'package:frontend/presentation/login/login_terms_information/login_terms_information_viewmodel.dart';
import 'package:frontend/presentation/login/login_view_model.dart';
import 'package:frontend/presentation/on_boarding/on_boarding_birth/on_boarding_birth_viewmodel.dart';
import 'package:frontend/presentation/on_boarding/on_boarding_job/on_boarding_job_viewmodel.dart';
import 'package:frontend/presentation/on_boarding/on_boarding_nickname/on_boarding_nickname_viewmodel.dart';
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

void getLoginTermsInformationBinding() {
  Get.put(LoginTermsInformationViewModel(
    kakaoLoginUseCase: kakaoLoginUseCase,
  ));
}

void getOnBoardingJobBinding() {
  Get.put(OnBoardingJobViewModel(
    kakaoLoginUseCase: kakaoLoginUseCase,
    accessTokenUseCase: accessTokenUseCase,
  ));
}

void getOnBoardingBirthBinding() {
  Get.put(OnBoardingBirthViewModel());
}

void getOnBoardingNickNameBinding() {
  Get.put(OnBoardingNicknameViewModel());
}
