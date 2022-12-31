import 'package:json_annotation/json_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookmark_data.freezed.dart';

part 'bookmark_data.g.dart';

@freezed
class BookmarkData with _$BookmarkData {
  factory BookmarkData({
    @Default(0) int id,
    @JsonKey(name: 'wise_saying_id') @Default(0) int wiseSayingId,
  }) = _BookmarkData;

  factory BookmarkData.fromJson(Map<String, dynamic> json) =>
      _$BookmarkDataFromJson(json);
}
