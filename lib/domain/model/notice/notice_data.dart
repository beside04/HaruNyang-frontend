import 'package:json_annotation/json_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notice_data.freezed.dart';

part 'notice_data.g.dart';

@freezed
class NoticeData with _$NoticeData {
  factory NoticeData({
    @Default('') String title,
    @Default('') String content,
    @JsonKey(name: 'created_at') @Default('') String createdAt,
    @JsonKey(name: 'updated_at') @Default('') String updateAt,
  }) = _NoticeData;

  factory NoticeData.fromJson(Map<String, dynamic> json) =>
      _$NoticeDataFromJson(json);
}
