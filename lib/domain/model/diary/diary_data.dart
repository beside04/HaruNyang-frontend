// import 'package:freezed_annotation/freezed_annotation.dart';
//
// part 'diary_data.freezed.dart';
// part 'diary_data.g.dart';
//
// @freezed
// class DiaryData with _$DiaryData {
//   factory DiaryData({
//     @JsonKey(name: 'id') int? id,
//     @JsonKey(name: 'content') required String diaryContent,
//     @JsonKey(name: 'feeling') required String feeling,
//     @JsonKey(name: 'feelingScore') required int feelingScore,
//     @Default('') String image,
//     @Default('') String? topic,
//     @JsonKey(name: 'weather') required String weather,
//     @JsonKey(name: 'targetDate') required String targetDate,
//     @Default(false) bool isAutoSave,
//   }) = _DiaryData;
//
//   factory DiaryData.fromJson(Map<String, dynamic> json) => _$DiaryDataFromJson(json);
// }
