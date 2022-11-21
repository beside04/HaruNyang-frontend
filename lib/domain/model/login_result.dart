import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_result.freezed.dart';

part 'login_result.g.dart';

@freezed
class LoginResult with _$LoginResult {
  factory LoginResult({
    @Default('') String accessToken,
    @Default(false) bool isSignup,
  }) = _LoginResult;

  factory LoginResult.fromJson(Map<String, dynamic> json) =>
      _$LoginResultFromJson(json);
}
