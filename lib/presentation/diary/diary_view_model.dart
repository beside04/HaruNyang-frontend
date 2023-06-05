import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/domain/model/emoticon_weather/emoticon_data.dart';
import 'package:frontend/domain/model/emoticon_weather/weather_data.dart';
import 'package:frontend/domain/use_case/emoticon_weather_use_case/get_emoticon_use_case.dart';
import 'package:frontend/domain/use_case/emoticon_weather_use_case/get_weather_use_case.dart';
import 'package:frontend/res/constants.dart';
import 'package:get/get.dart';

class DiaryViewModel extends GetxController
    with GetSingleTickerProviderStateMixin {
  final GetEmoticonUseCase getEmoticonUseCase;
  final GetWeatherUseCase getWeatherUseCase;

  DiaryViewModel({
    required this.getEmoticonUseCase,
    required this.getWeatherUseCase,
  }) {
    getWeatherData();
  }

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

  final Rx<EmoticonData> selectedEmotion =
      EmoticonData(emoticon: '', value: '', desc: '').obs;

  final RxList<WeatherData> weatherDataList = <WeatherData>[
    WeatherData(
      weather: 'lib/config/assets/images/diary/weather/sunny.svg',
      value: 'SUNNY',
      desc: '맑음',
    ),
    WeatherData(
      weather: 'lib/config/assets/images/diary/weather/cloudy.svg',
      value: 'CLOUDY',
      desc: '흐림',
    ),
    WeatherData(
      weather: 'lib/config/assets/images/diary/weather/rainy.svg',
      value: 'RAINY',
      desc: '비',
    ),
    WeatherData(
      weather: 'lib/config/assets/images/diary/weather/snow.svg',
      value: 'SNOWY',
      desc: '눈',
    ),
    WeatherData(
      weather: 'lib/config/assets/images/diary/weather/windy.svg',
      value: 'WINDY',
      desc: '바람',
    ),
    WeatherData(
      weather: 'lib/config/assets/images/diary/weather/thunder.svg',
      value: 'THUNDER',
      desc: '번개',
    ),
  ].obs;
  final Rx<WeatherData> selectedWeather =
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

  Future<void> getEmoticonData() async {
    int limit = getEmoticonLimitCount;
    int page = 0;
    final result = await getEmoticonUseCase(limit, page);

    await result.when(
      success: (data) async {
        emoticonDataList.value = data;
        for (final emoticon in data) {
          await precachePicture(
              NetworkPicture(
                SvgPicture.svgByteDecoderBuilder,
                emoticon.emoticon,
              ),
              null);
        }
      },
      error: (message) {
        Get.snackbar('알림', message);
      },
    );
  }

  Future<void> getWeatherData() async {
    final result = await getWeatherUseCase();

    await result.when(
      success: (data) async {
        weatherDataList.value = data;
        for (final weather in data) {
          await precachePicture(
              NetworkPicture(
                SvgPicture.svgByteDecoderBuilder,
                weather.weather,
              ),
              null);
        }
      },
      error: (message) {
        Get.snackbar('알림', message);
      },
    );
  }

  void setSelectedEmoticon(EmoticonData emoticon) {
    selectedEmotion.value = emoticon;
  }
}
