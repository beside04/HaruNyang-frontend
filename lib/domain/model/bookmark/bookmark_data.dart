import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/domain/model/wise_saying/wise_saying_data.dart';

part 'bookmark_data.freezed.dart';

part 'bookmark_data.g.dart';

@freezed
class BookmarkData with _$BookmarkData {
  factory BookmarkData({
    @JsonKey(name: 'id') @Default(0) int id,
    @JsonKey(name: 'wise_saying') required WiseSayingData wiseSaying,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _BookmarkData;

  factory BookmarkData.fromJson(Map<String, dynamic> json) => _$BookmarkDataFromJson(json);
}
