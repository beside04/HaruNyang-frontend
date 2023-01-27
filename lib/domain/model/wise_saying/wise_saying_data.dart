import 'package:freezed_annotation/freezed_annotation.dart';

part 'wise_saying_data.freezed.dart';

part 'wise_saying_data.g.dart';

@freezed
class WiseSayingData with _$WiseSayingData {
  factory WiseSayingData({
    int? id,
    @Default('') String author,
    @Default('') String message,
  }) = _WiseSayingData;

  factory WiseSayingData.fromJson(Map<String, dynamic> json) =>
      _$WiseSayingDataFromJson(json);
}
