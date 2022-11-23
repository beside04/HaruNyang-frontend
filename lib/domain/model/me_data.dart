import 'package:freezed_annotation/freezed_annotation.dart';

part 'me_data.freezed.dart';

part 'me_data.g.dart';

@freezed
class meData with _$meData {
  factory meData({
    @Default(1) @JsonKey(name: 'id') int id,
    @Default('') @JsonKey(name: 'login_type') String loginType,
    @Default(true) @JsonKey(name: 'deleted') bool deleted,
  }) = _meData;

  factory meData.fromJson(Map<String, dynamic> json) => _$meDataFromJson(json);
}
