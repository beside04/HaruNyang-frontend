import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/domain/model/diary/diary_detail_data.dart';

part 'diary_card_data.freezed.dart';
part 'diary_card_data.g.dart';

@freezed
class DiaryCardData with _$DiaryCardData {
  factory DiaryCardData({
    @Default([]) List<DiaryDetailData> diaryDataList,
    @Default('') String title,
  }) = _DiaryCardData;

  factory DiaryCardData.fromJson(Map<String, dynamic> json) => _$DiaryCardDataFromJson(json);
}
