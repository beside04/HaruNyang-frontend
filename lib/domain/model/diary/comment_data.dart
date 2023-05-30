import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/domain/model/emoticon_weather/emoticon_data.dart';
import 'package:frontend/domain/model/topic/topic_data.dart';
import 'package:frontend/domain/model/wise_saying/wise_saying_data.dart';

part 'comment_data.freezed.dart';

part 'comment_data.g.dart';

@freezed
class CommentData with _$CommentData {
  factory CommentData({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'diaryId') int? diaryId,
    @Default('') @JsonKey(name: 'message') String message,
    @Default('') @JsonKey(name: 'author') String author,
    @Default(false) @JsonKey(name: 'isFavorite') bool isFavorite,
    @Default('') @JsonKey(name: 'createAt') String createTime,
    @Default('') @JsonKey(name: 'updateAt') String updateTime,
  }) = _CommentData;

  factory CommentData.fromJson(Map<String, dynamic> json) =>
      _$CommentDataFromJson(json);
}
