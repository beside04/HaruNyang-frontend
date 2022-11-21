import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

part 'login_state.g.dart';

@freezed
class LoginState with _$LoginState {
  factory LoginState({
    @Default('') String socialId,
    @Default('') String email,
  }) = _LoginState;

  factory LoginState.fromJson(Map<String, dynamic> json) =>
      _$LoginStateFromJson(json);
}
