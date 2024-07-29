import 'package:freezed_annotation/freezed_annotation.dart';

part 'banner_data.freezed.dart';
part 'banner_data.g.dart';

@freezed
class BannerData with _$BannerData {
  factory BannerData({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'writer') required String writer,
    @JsonKey(name: 'title') @Default('') String title,
    @JsonKey(name: 'content') @Default('') String content,
    @JsonKey(name: 'image') @Default('') String image,
    @JsonKey(name: 'landingUrl') required String landingUrl,
    @JsonKey(name: 'activated') required bool activated,
    @JsonKey(name: 'viewOrder') required int viewOrder,
    @JsonKey(name: 'hit') required int hit,
    @JsonKey(name: 'startAt') required int startAt,
    @JsonKey(name: 'endAt') required int endAt,
    @JsonKey(name: 'createAt') @Default('') String createdAt,
    @JsonKey(name: 'updateAt') @Default('') String updateAt,
  }) = _BannerData;

  factory BannerData.fromJson(Map<String, dynamic> json) => _$BannerDataFromJson(json);
}
