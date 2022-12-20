import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/domain/model/Emoticon/emoticon_data.dart';
import 'package:frontend/domain/model/wise_saying/wise_saying_data.dart';

part 'emotion_stamp_data.freezed.dart';

part 'emotion_stamp_data.g.dart';

@freezed
class EmotionStampData with _$EmotionStampData {
  factory EmotionStampData({
    @Default('') @JsonKey(name: 'content') String? content,
    @Default(0) @JsonKey(name: 'user_id') int? userId,
    @Default(null) @JsonKey(name: 'emotion') EmoticonData? emotion,
    @Default(null) @JsonKey(name: 'emotion_index') int? emotionIndex,
    @Default(null)
    @JsonKey(name: 'wise_sayings')
        List<WiseSayingData>? wiseSayings,
    @Default(null) @JsonKey(name: 'weather') String? weather,
    @Default(null) @JsonKey(name: 'images') List<String>? images,
    @Default(null) @JsonKey(name: 'created_at') String? createdAt,
    @Default(null) @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _EmotionStampData;

  factory EmotionStampData.fromJson(Map<String, dynamic> json) =>
      _$EmotionStampDataFromJson(json);
}
