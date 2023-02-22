import 'package:freezed_annotation/freezed_annotation.dart';

part 'topic_data.freezed.dart';

part 'topic_data.g.dart';

@freezed
class TopicData with _$TopicData {
  factory TopicData({
    required int id,
    required String value,
  }) = _TopicData;

  factory TopicData.fromJson(Map<String, dynamic> json) =>
      _$TopicDataFromJson(json);
}
