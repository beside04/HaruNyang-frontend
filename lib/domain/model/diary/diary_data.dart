import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/domain/model/emoticon_weather/emoticon_data.dart';
import 'package:frontend/domain/model/topic/topic_data.dart';
import 'package:frontend/domain/model/wise_saying/wise_saying_data.dart';

part 'diary_data.freezed.dart';

part 'diary_data.g.dart';

@freezed
class DiaryData with _$DiaryData {
  factory DiaryData({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'content') required String diaryContent,
    @JsonKey(name: 'feeling') required String feeling,
    @JsonKey(name: 'feelingScore') required int feelingScore,
    @JsonKey(name: 'weather') required String weather,
    @JsonKey(name: 'targetDate') required String targetDate,
  }) = _DiaryData;

  factory DiaryData.fromJson(Map<String, dynamic> json) =>
      _$DiaryDataFromJson(json);
}
