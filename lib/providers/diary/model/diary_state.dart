import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/domain/model/banner/banner_data.dart';
import 'package:frontend/domain/model/diary/comment_data.dart';
import 'package:frontend/domain/model/diary/diary_card_data.dart';
import 'package:frontend/domain/model/diary/diary_detail_data.dart';
import 'package:frontend/domain/model/wise_saying/wise_saying_data.dart';

part 'diary_state.freezed.dart';
part 'diary_state.g.dart';

@freezed
class DiaryState with _$DiaryState {
  factory DiaryState({
    DiaryDetailData? diary,
    @Default([]) List<WiseSayingData> wiseSayingList,
    @Default('') String networkImage,
    @Default(false) bool isLoading,
    @Default(false) bool isCalendarLoading,
    @Default(true) bool isCalendar,
    @Default([]) List<DiaryDetailData> diaryDataList,
    @Default([]) List<DiaryCardData> diaryCardDataList,
    @Default([]) List<CommentData> bookmarkList,
    required DateTime focusedStartDate,
    required DateTime focusedEndDate,
    required DateTime focusedCalendarDate,
    required DateTime selectedCalendarDate,
    @Default(250) int currentPageCount,
    @Default(false) bool isNote,
    @Default(null) DiaryDetailData? diaryDetailData,
    @Default([]) List<BannerData> bannerList,
  }) = _DiaryState;

  factory DiaryState.fromJson(Map<String, dynamic> json) => _$DiaryStateFromJson(json);
}
