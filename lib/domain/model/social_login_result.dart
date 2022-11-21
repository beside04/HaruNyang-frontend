import 'package:freezed_annotation/freezed_annotation.dart';

part 'social_login_result.freezed.dart';

part 'social_login_result.g.dart';

@freezed
class SocialLoginResult with _$SocialLoginResult {
  factory SocialLoginResult({
    @Default('') String email,
    @Default('') String socialId,
  }) = _SocialLoginResult;

  factory SocialLoginResult.fromJson(Map<String, dynamic> json) =>
      _$SocialLoginResultFromJson(json);
}
