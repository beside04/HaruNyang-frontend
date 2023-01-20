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
    @Default(false) isLoading,
  }) = _DiaryState;

  factory DiaryState.fromJson(Map<String, dynamic> json) =>
      _$DiaryStateFromJson(json);
}
