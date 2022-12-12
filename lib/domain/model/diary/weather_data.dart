import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather_data.freezed.dart';

part 'weather_data.g.dart';

@freezed
class WeatherData with _$WeatherData {
  factory WeatherData({
    required String name,
    required String icon,
    required String value,
  }) = _WeatherData;

  factory WeatherData.fromJson(Map<String, dynamic> json) =>
      _$WeatherDataFromJson(json);
}
