import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/domain/model/diary/comment_data.dart';

part 'diary_detail_data.freezed.dart';

part 'diary_detail_data.g.dart';

@freezed
class DiaryDetailData with _$DiaryDetailData {
  factory DiaryDetailData({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'content') required String diaryContent,
    @JsonKey(name: 'feeling') required String feeling,
    @JsonKey(name: 'feelingScore') required int feelingScore,
    @JsonKey(name: 'weather') required String weather,
    @JsonKey(name: 'topic') required String topic,
    @JsonKey(name: 'image') required String image,
    @JsonKey(name: 'comments') required List<CommentData> comments,
    @JsonKey(name: 'targetDate') required String targetDate,
    @JsonKey(name: 'createAt') required String createAt,
    @JsonKey(name: 'updateAt') required String updateAt,
  }) = _DiaryDetailData;

  factory DiaryDetailData.fromJson(Map<String, dynamic> json) =>
      _$DiaryDetailDataFromJson(json);
}
