import 'package:freezed_annotation/freezed_annotation.dart';

part 'password_state.freezed.dart';
part 'password_state.g.dart';

@freezed
class PasswordState with _$PasswordState {
  factory PasswordState({
    @Default(0) int selectedIndex,
  }) = _PasswordState;

  factory PasswordState.fromJson(Map<String, dynamic> json) => _$PasswordStateFromJson(json);
}
