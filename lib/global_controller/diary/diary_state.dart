import 'package:frontend/domain/model/diary/diary_card_data.dart';
import 'package:frontend/domain/model/diary/diary_data.dart';
import 'package:frontend/domain/model/wise_saying/wise_saying_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'diary_state.freezed.dart';

part 'diary_state.g.dart';

@freezed
class DiaryState with _$DiaryState {
  factory DiaryState({
    DiaryData? diary,
    @Default([]) List<WiseSayingData> wiseSayingList,
    @Default('') String networkImage,
    @Default(false) bool isLoading,
    @Default(false) bool isCalendarLoading,
    @Default(true) bool isCalendar,
    @Default([]) List<DiaryData> diaryDataList,
    @Default([]) List<DiaryCardData> diaryCardDataList,
    required DateTime focusedStartDate,
    required DateTime focusedEndDate,
    required DateTime focusedCalendarDate,
    required DateTime selectedCalendarDate,
  }) = _DiaryState;

  factory DiaryState.fromJson(Map<String, dynamic> json) =>
      _$DiaryStateFromJson(json);
}
