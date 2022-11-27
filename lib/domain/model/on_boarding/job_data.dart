import 'package:freezed_annotation/freezed_annotation.dart';

part 'job_data.freezed.dart';

part 'job_data.g.dart';

@freezed
class JobData with _$JobData {
  factory JobData({
    required String name,
    required String icon,
    required String value,
  }) = _JobData;

  factory JobData.fromJson(Map<String, dynamic> json) =>
      _$JobDataFromJson(json);
}
