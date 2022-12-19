import 'package:json_annotation/json_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'diary_data.freezed.dart';

part 'diary_data.g.dart';

@freezed
class DiaryData with _$DiaryData {
  factory DiaryData({
    required String diaryContent,
    required int emoticonId,
    required int emoticonIndex,
    required List<String> images,
    required String weather,
    required List<int> wiseSayingIds,
  }) = _DiaryData;

  factory DiaryData.fromJson(Map<String, dynamic> json) =>
      _$DiaryDataFromJson(json);
}
