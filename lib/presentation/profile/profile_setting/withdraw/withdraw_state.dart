import 'package:freezed_annotation/freezed_annotation.dart';

part 'withdraw_state.freezed.dart';

part 'withdraw_state.g.dart';

@freezed
class WithdrawState with _$WithdrawState {
  factory WithdrawState({
    @Default(false) bool isAgreeWithdrawTerms,
  }) = _WithdrawState;

  factory WithdrawState.fromJson(Map<String, dynamic> json) =>
      _$WithdrawStateFromJson(json);
}
