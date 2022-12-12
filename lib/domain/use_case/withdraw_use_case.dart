import 'package:frontend/domain/repository/withdraw_repository.dart';

class WithdrawUseCase {
  final WithdrawRepository withdrawRepository;

  WithdrawUseCase({
    required this.withdrawRepository,
  });

  Future<void> withdrawUser() async {
    return withdrawRepository.withdrawUser();
  }
}
