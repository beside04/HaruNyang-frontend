import 'package:json_annotation/json_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_result_data.freezed.dart';

part 'login_result_data.g.dart';

@freezed
class LoginResultData with _$LoginResultData {
  factory LoginResultData({
    @Default('') @JsonKey(name: 'access_token') String accessToken,
    @Default('') @JsonKey(name: 'refresh_token') String refreshToken,
  }) = _LoginResultData;

  factory LoginResultData.fromJson(Map<String, dynamic> json) =>
      _$LoginResultDataFromJson(json);
}
