import 'package:frontend/core/result.dart';
import 'package:frontend/domain/repository/withdraw/withdraw_repository.dart';
import 'package:frontend/domain/use_case/token_use_case.dart';

class WithdrawUseCase {
  final WithdrawRepository withdrawRepository;
  final TokenUseCase tokenUseCase;

  WithdrawUseCase({
    required this.withdrawRepository,
    required this.tokenUseCase,
  });

  Future<Result<bool>> withdrawUser() async {
    final result = await withdrawRepository.withdrawUser();
    await result.when(
      success: (isSuccess) async {
        await tokenUseCase.deleteAllToken();
      },
      error: (message) {},
    );
    return result;
  }
}
