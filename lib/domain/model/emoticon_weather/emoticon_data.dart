import 'package:freezed_annotation/freezed_annotation.dart';
part 'emoticon_data.freezed.dart';
part 'emoticon_data.g.dart';

@freezed
class EmoticonData with _$EmoticonData {
  factory EmoticonData({
    int? id,
    required String emoticon,
    required String value,
    required String desc,
  }) = _EmoticonData;
  factory EmoticonData.fromJson(Map<String, dynamic> json) =>
      _$EmoticonDataFromJson(json);
}
