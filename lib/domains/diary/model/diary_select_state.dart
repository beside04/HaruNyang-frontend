import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/domain/model/emoticon_weather/emoticon_data.dart';
import 'package:frontend/domain/model/emoticon_weather/weather_data.dart';

part 'diary_select_state.freezed.dart';

part 'diary_select_state.g.dart';

@freezed
class DiarySelectState with _$DiarySelectState {
  factory DiarySelectState({
    @Default(true) bool isEmotionModal,
    @Default(2.0) double emotionNumberValue,
    @Default("맞아") String? emotionTextValue,
    @Default([
      EmoticonData(
        emoticon: 'lib/config/assets/images/character/happy.png',
        value: 'HAPPINESS',
        desc: '기뻐',
      ),
      EmoticonData(
        emoticon: 'lib/config/assets/images/character/sad2.png',
        value: 'SADNESS',
        desc: '슬퍼',
      ),
      EmoticonData(
        emoticon: 'lib/config/assets/images/character/angry.png',
        value: 'ANGRY',
        desc: '화나',
      ),
      EmoticonData(
        emoticon: 'lib/config/assets/images/character/excited.png',
        value: 'EXCITED',
        desc: '신나',
      ),
      EmoticonData(
        emoticon: 'lib/config/assets/images/character/tired.png',
        value: 'TIRED',
        desc: '힘들어',
      ),
      EmoticonData(
        emoticon: 'lib/config/assets/images/character/amazed.png',
        value: 'SURPRISED',
        desc: '놀랐어',
      ),
      EmoticonData(
        emoticon: 'lib/config/assets/images/character/soso.png',
        value: 'NEUTRAL',
        desc: '그저그래',
      ),
      EmoticonData(
        emoticon: 'lib/config/assets/images/character/blushed.png',
        value: 'FLUTTER',
        desc: '설레',
      ),
      EmoticonData(
        emoticon: 'lib/config/assets/images/character/molra.png',
        value: 'UNCERTAIN',
        desc: '몰라',
      ),
    ])
    List<EmoticonData> emoticonDataList,
    @Default(EmoticonData(emoticon: '', value: '', desc: '')) EmoticonData selectedEmotion,
    @Default([
      WeatherData(
        weather: 'lib/config/assets/images/diary/weather/sunny.png',
        value: 'SUNNY',
        desc: '맑음',
      ),
      WeatherData(
        weather: 'lib/config/assets/images/diary/weather/cloudy.png',
        value: 'CLOUDY',
        desc: '흐림',
      ),
      WeatherData(
        weather: 'lib/config/assets/images/diary/weather/rainy.png',
        value: 'RAINY',
        desc: '비',
      ),
      WeatherData(
        weather: 'lib/config/assets/images/diary/weather/snowy.png',
        value: 'SNOWY',
        desc: '눈',
      ),
      WeatherData(
        weather: 'lib/config/assets/images/diary/weather/windy.png',
        value: 'WINDY',
        desc: '바람',
      ),
      WeatherData(
        weather: 'lib/config/assets/images/diary/weather/thunder.png',
        value: 'THUNDER',
        desc: '번개',
      ),
    ])
    List<WeatherData> weatherDataList,
    @Default(WeatherData(weather: '', value: '', desc: '')) WeatherData selectedWeather,
  }) = _DiarySelectState;

  factory DiarySelectState.fromJson(Map<String, dynamic> json) => _$DiarySelectStateFromJson(json);
}
