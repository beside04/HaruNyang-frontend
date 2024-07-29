import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/domain/use_case/withdraw/withdraw_use_case.dart';
import 'package:frontend/providers/profile/model/withdraw_state.dart';
import 'package:frontend/utils/utils.dart';

final withdrawProvider = StateNotifierProvider<NoticeNotifier, WithdrawState>((ref) {
  return NoticeNotifier(
    ref,
    withDrawUseCase,
  );
});

class NoticeNotifier extends StateNotifier<WithdrawState> {
  NoticeNotifier(this.ref, this.withDrawUseCase) : super(WithdrawState());

  final Ref ref;
  final WithdrawUseCase withDrawUseCase;

  void changeWithdrawTerms(bool value) {
    GlobalUtils.setAnalyticsCustomEvent('Click_WithdrawTerms_${value.toString()}');
    state = state.copyWith(
      isAgreeWithdrawTerms: value,
    );
  }

  Future<bool> withdrawUser(bool isKakao) async {
    bool isSuccessWithdraw = false;

    final result = await withDrawUseCase.withdrawUser(isKakao);
    result.when(
      success: (isSuccess) {
        isSuccessWithdraw = isSuccess;
      },
      error: (message) {
        // Get.snackbar('알림', '회원 탈퇴에 실패 했습니다.');
      },
    );

    return isSuccessWithdraw;
  }
}
