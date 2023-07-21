import 'package:frontend/domain/model/emoticon_weather/emoticon_data.dart';
import 'package:frontend/domain/model/emoticon_weather/weather_data.dart';
import 'package:get/get.dart';

class DiaryViewModel extends GetxController
    with GetSingleTickerProviderStateMixin {
  final isEmotionModal = true.obs;
  final emotionNumberValue = 2.0.obs;
  final emotionTextValue = '맞아!'.obs;

  final RxList<EmoticonData> emoticonDataList = <EmoticonData>[
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
  ].obs;

  Rx<EmoticonData> selectedEmotion =
      EmoticonData(emoticon: '', value: '', desc: '').obs;

  final RxList<WeatherData> weatherDataList = <WeatherData>[
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
  ].obs;
  Rx<WeatherData> selectedWeather =
      WeatherData(weather: '', value: '', desc: '').obs;

  void popDownEmotionModal() {
    isEmotionModal.value = false;
    update();
  }

  void popUpEmotionModal() {
    isEmotionModal.value = true;
    update();
  }

  getEmotionValue() {
    if (emotionNumberValue.value < 1.0) {
      emotionTextValue.value = '조금?';
    } else if (emotionNumberValue.value < 2.0) {
      emotionTextValue.value = '그럭저럭';
    } else if (emotionNumberValue.value < 3.0) {
      emotionTextValue.value = '맞아!';
    } else {
      emotionTextValue.value = '진짜 엄청 대박!!';
    }
  }

  void setSelectedEmoticon(EmoticonData emoticon) {
    selectedEmotion.value = emoticon;
  }
}
