import 'package:frontend/core/result.dart';
import 'package:frontend/data/data_source/remote_data/emoticon_weather_api.dart';
import 'package:frontend/domain/model/emoticon_weather/emoticon_data.dart';
import 'package:frontend/domain/model/emoticon_weather/weather_data.dart';
import 'package:frontend/domain/repository/emoticon_weather/emoticon_repository.dart';

class EmoticonRepositoryImpl implements EmoticonWeatherRepository {
  final EmoticonWeatherApi _dataSource = EmoticonWeatherApi();

  @override
  Future<Result<List<EmoticonData>>> getEmoticon(int limit, int page) async {
    final result = await _dataSource.getEmoticons(limit, page);
    return result;
  }

  @override
  Future<Result<List<WeatherData>>> getWeather() async {
    final result = await _dataSource.getWeather();
    return result;
  }
}
