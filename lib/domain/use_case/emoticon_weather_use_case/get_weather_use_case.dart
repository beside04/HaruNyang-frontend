import 'package:frontend/core/result.dart';
import 'package:frontend/domain/model/emoticon_weather/weather_data.dart';
import 'package:frontend/domain/repository/emoticon_weather/emoticon_repository.dart';

class GetWeatherUseCase {
  final EmoticonWeatherRepository weatherRepository;

  GetWeatherUseCase({
    required this.weatherRepository,
  });

  Future<Result<List<WeatherData>>> call() async {
    return await weatherRepository.getWeather();
  }
}
