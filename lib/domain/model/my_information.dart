import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_information.freezed.dart';

part 'my_information.g.dart';

@freezed
class MyInformation with _$MyInformation {
  factory MyInformation({
    @Default(1) @JsonKey(name: 'id') int id,
    @Default('') @JsonKey(name: 'login_type') String loginType,
    @Default(false) @JsonKey(name: 'deleted') bool deleted,
    @Default(null) @JsonKey(name: 'nickname') String? nickname,
    @Default(null) @JsonKey(name: 'job') String? job,
    @Default(null) @JsonKey(name: 'age') String? age,
    @Default(null) @JsonKey(name: 'email') String? email,
  }) = _MyInformation;

  factory MyInformation.fromJson(Map<String, dynamic> json) =>
      _$MyInformationFromJson(json);
}
