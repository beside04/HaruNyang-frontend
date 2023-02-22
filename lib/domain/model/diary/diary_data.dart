import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/domain/model/emoticon_weather/emoticon_data.dart';
import 'package:frontend/domain/model/topic/topic_data.dart';
import 'package:frontend/domain/model/wise_saying/wise_saying_data.dart';

part 'diary_data.freezed.dart';

part 'diary_data.g.dart';

@freezed
class DiaryData with _$DiaryData {
  factory DiaryData({
    String? id,
    @JsonKey(name: 'content') required String diaryContent,
    required EmoticonData emotion,
    @JsonKey(name: 'emotion_index') required int emoticonIndex,
    required List<String> images,
    required String weather,
    @JsonKey(name: 'wise_sayings') required List<WiseSayingData> wiseSayings,
    @Default('') @JsonKey(name: 'created_at') String createTime,
    @Default('') @JsonKey(name: 'updated_at') String updateTime,
    @Default('') @JsonKey(name: 'written_at') String writtenAt,
    @JsonKey(name: 'writing_topic') required TopicData writingTopic,
  }) = _DiaryData;

  factory DiaryData.fromJson(Map<String, dynamic> json) =>
      _$DiaryDataFromJson(json);
}
