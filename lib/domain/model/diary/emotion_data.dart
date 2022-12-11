import 'package:freezed_annotation/freezed_annotation.dart';

part 'emotion_data.freezed.dart';

part 'emotion_data.g.dart';

@freezed
class EmotionData with _$EmotionData {
  factory EmotionData(
      {required String name,
      required String icon,
      required String value,
      required String writeValue,
      required}) = _EmotionData;

  factory EmotionData.fromJson(Map<String, dynamic> json) =>
      _$EmotionDataFromJson(json);
}
