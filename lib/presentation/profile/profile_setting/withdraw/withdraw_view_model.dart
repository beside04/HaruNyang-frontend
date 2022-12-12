import 'package:frontend/domain/use_case/withdraw_use_case.dart';
import 'package:frontend/presentation/profile/profile_setting/withdraw/withdraw_state.dart';
import 'package:get/get.dart';

class WithdrawViewModel extends GetxController {
  final WithdrawUseCase withdrawUseCase;

  WithdrawViewModel({
    required this.withdrawUseCase,
  });

  final Rx<WithdrawState> _state = WithdrawState().obs;

  Rx<WithdrawState> get state => _state;

  void changeWithdrawTerms(bool value) {
    _state.value = state.value.copyWith(
      isAgreeWithdrawTerms: value,
    );
  }

  Future<void> withdrawUser() async {
    await withdrawUseCase.withdrawUser();
  }
}