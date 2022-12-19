import 'package:frontend/core/result.dart';
import 'package:frontend/domain/repository/withdraw/withdraw_repository.dart';
import 'package:frontend/domain/use_case/on_boarding_use_case/on_boarding_use_case.dart';
import 'package:frontend/domain/use_case/social_login_use_case/apple_login_use_case.dart';
import 'package:frontend/domain/use_case/social_login_use_case/kakao_login_use_case.dart';

class WithdrawUseCase {
  final WithdrawRepository withdrawRepository;
  final OnBoardingUseCase onBoardingUseCase;
  final KakaoLoginUseCase kakaoLoginUseCase;
  final AppleLoginUseCase appleLoginUseCase;

  WithdrawUseCase({
    required this.withdrawRepository,
    required this.onBoardingUseCase,
    required this.kakaoLoginUseCase,
    required this.appleLoginUseCase,
  });

  Future<Result<bool>> withdrawUser(bool isKakao) async {
    final result = await withdrawRepository.withdrawUser();
    await result.when(
      success: (isSuccess) async {
        if (isKakao) {
          kakaoLoginUseCase.withdrawal();
        } else {
          appleLoginUseCase.withdrawal();
        }
        onBoardingUseCase.clearMyInformation();
      },
      error: (message) {},
    );
    return result;
  }
}
