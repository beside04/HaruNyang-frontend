import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_information.freezed.dart';

part 'my_information.g.dart';

@freezed
class MyInformation with _$MyInformation {
  factory MyInformation({
    @Default(null) @JsonKey(name: 'nickname') String? nickname,
    @Default(null) @JsonKey(name: 'job') String? job,
    @Default(null) @JsonKey(name: 'birthDate') String? age,
    @Default(null) @JsonKey(name: 'email') String? email,
  }) = _MyInformation;

  factory MyInformation.fromJson(Map<String, dynamic> json) =>
      _$MyInformationFromJson(json);
}
