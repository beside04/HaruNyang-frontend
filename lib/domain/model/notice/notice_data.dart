import 'package:freezed_annotation/freezed_annotation.dart';

part 'notice_data.freezed.dart';

part 'notice_data.g.dart';

@freezed
class NoticeData with _$NoticeData {
  factory NoticeData({
    @JsonKey(name: 'title') @Default('') String title,
    @JsonKey(name: 'content') @Default('') String content,
    @JsonKey(name: 'image') @Default('') String image,
    @JsonKey(name: 'createAt') @Default('') String createdAt,
    @JsonKey(name: 'updateAt') @Default('') String updateAt,
  }) = _NoticeData;

  factory NoticeData.fromJson(Map<String, dynamic> json) =>
      _$NoticeDataFromJson(json);
}
