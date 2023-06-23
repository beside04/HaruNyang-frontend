import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/domain/model/diary/comment_data.dart';

part 'calendar_data.freezed.dart';

part 'calendar_data.g.dart';

@freezed
class CalendarData with _$CalendarData {
  factory CalendarData({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'content') required String diaryContent,
    @JsonKey(name: 'feeling') required String feeling,
    @JsonKey(name: 'feelingScore') required int feelingScore,
    @JsonKey(name: 'weather') required String weather,
    @JsonKey(name: 'topic') required String topic,
    @JsonKey(name: 'image') required String image,
    @JsonKey(name: 'comments') required List<CommentData> comments,
    @JsonKey(name: 'targetDate') required String targetDate,
    @Default('') @JsonKey(name: 'createAt') String createTime,
    @Default('') @JsonKey(name: 'updateAt') String updateTime,
  }) = _CalendarData;

  factory CalendarData.fromJson(Map<String, dynamic> json) =>
      _$CalendarDataFromJson(json);
}
