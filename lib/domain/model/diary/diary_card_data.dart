import 'package:frontend/domain/model/diary/diary_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'diary_card_data.freezed.dart';

part 'diary_card_data.g.dart';

@freezed
class DiaryCardData with _$DiaryCardData {
  factory DiaryCardData({
    @Default([]) List<DiaryData> diaryDataList,
    @Default('') String title,
  }) = _DiaryCardData;

  factory DiaryCardData.fromJson(Map<String, dynamic> json) =>
      _$DiaryCardDataFromJson(json);
}
