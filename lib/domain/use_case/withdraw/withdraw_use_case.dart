import 'package:frontend/apis/response_result.dart';
import 'package:frontend/domain/repository/withdraw/withdraw_repository.dart';
import 'package:frontend/domain/use_case/social_login_use_case/apple_login_use_case.dart';
import 'package:frontend/domain/use_case/social_login_use_case/kakao_login_use_case.dart';

class WithdrawUseCase {
  final WithdrawRepository withdrawRepository;
  final KakaoLoginUseCase kakaoLoginUseCase;
  final AppleLoginUseCase appleLoginUseCase;

  WithdrawUseCase({
    required this.withdrawRepository,
    required this.kakaoLoginUseCase,
    required this.appleLoginUseCase,
  });

  Future<ResponseResult<bool>> withdrawUser(bool isKakao) async {
    final result = await withdrawRepository.withdrawUser();
    await result.when(
      success: (isSuccess) async {
        if (isKakao) {
          kakaoLoginUseCase.withdrawal();
        } else {
          appleLoginUseCase.withdrawal();
        }
      },
      error: (message) {},
    );
    return result;
  }
}
