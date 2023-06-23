import 'package:freezed_annotation/freezed_annotation.dart';

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
    @Default('') @JsonKey(name: 'createAt') String createAt,
    @Default('') @JsonKey(name: 'updateAt') String updateAt,
  }) = _CommentData;

  factory CommentData.fromJson(Map<String, dynamic> json) =>
      _$CommentDataFromJson(json);
}
