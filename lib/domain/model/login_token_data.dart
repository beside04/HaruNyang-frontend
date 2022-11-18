import 'package:json_annotation/json_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_token_data.freezed.dart';

part 'login_token_data.g.dart';

@freezed
class LoginTokenData with _$LoginTokenData {
  factory LoginTokenData({
    @Default('') @JsonKey(name: 'access_token') String accessToken,
    @Default('') @JsonKey(name: 'refresh_token') String refreshToken,
  }) = _LoginTokenData;

  factory LoginTokenData.fromJson(Map<String, dynamic> json) =>
      _$LoginTokenDataFromJson(json);
}
