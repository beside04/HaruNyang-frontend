import 'package:frontend/core/result.dart';
import 'package:frontend/domain/model/emoticon_weather/emoticon_data.dart';
import 'package:frontend/domain/model/emoticon_weather/weather_data.dart';

abstract class EmoticonWeatherRepository {
  Future<Result<List<EmoticonData>>> getEmoticon(int limit, int page);

  Future<Result<List<WeatherData>>> getWeather();
}
