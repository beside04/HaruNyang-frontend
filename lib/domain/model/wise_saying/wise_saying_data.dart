import 'package:freezed_annotation/freezed_annotation.dart';

part 'wise_saying_data.freezed.dart';

part 'wise_saying_data.g.dart';

@freezed
class WiseSayingData with _$WiseSayingData {
  factory WiseSayingData({
    @JsonKey(name: 'id') @Default(0) int id,
    @JsonKey(name: 'diaryId') @Default(0) int diaryId,
    @JsonKey(name: 'message') @Default('') String message,
    @JsonKey(name: 'author') @Default('') String author,
    @JsonKey(name: 'isFavorite') @Default(false) bool isFavorite,
    @JsonKey(name: 'createAt') @Default('') String createAt,
    @JsonKey(name: 'updateAt') @Default('') String updateAt,
  }) = _WiseSayingData;

  factory WiseSayingData.fromJson(Map<String, dynamic> json) =>
      _$WiseSayingDataFromJson(json);
}
