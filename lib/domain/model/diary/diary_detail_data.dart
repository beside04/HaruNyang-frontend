import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/domain/model/diary/comment_data.dart';

part 'diary_detail_data.freezed.dart';
part 'diary_detail_data.g.dart';

@freezed
class DiaryDetailData with _$DiaryDetailData {
  factory DiaryDetailData({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'content') required String diaryContent,
    @JsonKey(name: 'feeling') required String feeling,
    @JsonKey(name: 'feelingScore') required int feelingScore,
    @JsonKey(name: 'weather') required String weather,
    @JsonKey(name: 'topic') String? topic,
    @JsonKey(name: 'image') String? image,
    @JsonKey(name: 'comments') List<CommentData>? comments,
    @JsonKey(name: 'targetDate') required String targetDate,
    @JsonKey(name: 'createAt') String? createAt,
    @JsonKey(name: 'updateAt') String? updateAt,
    @Default(false) bool isAutoSave,
  }) = _DiaryDetailData;

  factory DiaryDetailData.fromJson(Map<String, dynamic> json) => _$DiaryDetailDataFromJson(json);
}
