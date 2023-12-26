import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

part 'login_state.g.dart';

@freezed
class LoginState with _$LoginState {
  factory LoginState({
    @Default("") String loginType,
    @Default(null) String? email,
    @Default("") String socialId,
    @Default(null) String? deviceToken,
    @Default("") String nickname,
    @Default("") String job,
    @Default("") String birthDate,
  }) = _LoginState;

  factory LoginState.fromJson(Map<String, dynamic> json) => _$LoginStateFromJson(json);
}
