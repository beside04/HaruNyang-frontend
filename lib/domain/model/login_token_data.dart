import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_token_data.freezed.dart';

part 'login_token_data.g.dart';

@freezed
class LoginTokenData with _$LoginTokenData {
  factory LoginTokenData({
    @Default('') String accessToken,
  }) = _LoginTokenData;

  factory LoginTokenData.fromJson(Map<String, dynamic> json) =>
      _$LoginTokenDataFromJson(json);
}
