import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/domain/model/emoticon_weather/emoticon_data.dart';
import 'package:frontend/domain/model/emoticon_weather/weather_data.dart';
import 'package:frontend/domain/use_case/emoticon_weather_use_case/get_emoticon_use_case.dart';
import 'package:frontend/domain/use_case/emoticon_weather_use_case/get_weather_use_case.dart';
import 'package:frontend/res/constants.dart';
import 'package:get/get.dart';

class DiaryViewModel extends GetxController
    with GetSingleTickerProviderStateMixin {
  List<String> weatherInfo = [
    'sunny',
    'rainy',
    'cloudy',
    'snow',
    'windy',
    'thunder'
  ];
  final GetEmoticonUseCase getEmoticonUseCase;
  final GetWeatherUseCase getWeatherUseCase;

  DiaryViewModel({
    required this.getEmoticonUseCase,
    required this.getWeatherUseCase,
  }) {
    getEmoticonData();
    getWeatherData();
  }

  final nowDate = DateTime.now().obs;
  final isEmotionModal = true.obs;
  final emotionNumberValue = 6.0.obs;
  final emotionTextValue = '맞아!'.obs;

  final RxList<EmoticonData> emoticonDataList = <EmoticonData>[].obs;
  final Rx<EmoticonData> selectedEmotion =
      EmoticonData(emoticon: '', value: '', desc: '').obs;

  final RxList<WeatherData> weatherDataList = <WeatherData>[].obs;
  final Rx<WeatherData> selectedWeather = WeatherData(image: '', value: '').obs;

  void popDownEmotionModal() {
    isEmotionModal.value = false;
    update();
  }

  void popUpEmotionModal() {
    isEmotionModal.value = true;
    update();
  }

  getEmotionValue() {
    if (emotionNumberValue.value < 2.0) {
      emotionTextValue.value = '조금?';
    } else if (emotionNumberValue.value < 5.0) {
      emotionTextValue.value = '그럭저럭';
    } else if (emotionNumberValue.value < 7.0) {
      emotionTextValue.value = '맞아!';
    } else {
      emotionTextValue.value = '진짜 엄청 대박!!';
    }
  }

  Future<void> getEmoticonData() async {
    List<EmoticonData> emotions = [
      EmoticonData(
        value: '기뻐',
        emoticon: 'lib/config/assets/images/diary/weather/sunny.svg',
        desc: '기뻐',
      ),
      EmoticonData(
        value: '슬퍼',
        emoticon: 'lib/config/assets/images/diary/weather/rainy.svg',
        desc: '슬퍼',
      ),
    ];
    emoticonDataList.value = emotions;
  }

  // Future<void> getEmoticonData() async {
  //   int limit = getEmoticonLimitCount;
  //   int page = 0;
  //   final result = await getEmoticonUseCase(limit, page);
  //
  //   await result.when(
  //     success: (data) async {
  //       emoticonDataList.value = data;
  //       for (final emoticon in data) {
  //         await precachePicture(
  //             NetworkPicture(
  //               SvgPicture.svgByteDecoderBuilder,
  //               emoticon.emoticon,
  //             ),
  //             null);
  //       }
  //     },
  //     error: (message) {
  //       Get.snackbar('알림', message);
  //     },
  //   );
  // }

  Future<void> getWeatherData() async {
    List<WeatherData> weathers = [
      WeatherData(
        image: 'lib/config/assets/images/diary/weather/sunny.svg',
        value: '맑음',
      ),
      WeatherData(
        image: 'lib/config/assets/images/diary/weather/rainy.svg',
        value: '비',
      ),
    ];
    weatherDataList.value = weathers;
  }

  // Future<void> getWeatherData() async {
  //   final result = await getWeatherUseCase();
  //
  //   await result.when(
  //     success: (data) async {
  //       List<WeatherData> weathers = [];
  //
  //       for (int i = 0; i < weatherInfo.length; i++) {
  //         for (int j = 0; j < data.length; j++) {
  //           if (weatherInfo[i] == data[j].value) {
  //             weathers.add(
  //               data[j].copyWith(
  //                 value: getWeatherNameKorean(data[j].value),
  //               ),
  //             );
  //             break;
  //           }
  //         }
  //       }
  //
  //       weatherDataList.value = weathers;
  //       for (final weather in weathers) {
  //         await precachePicture(
  //             NetworkPicture(
  //               SvgPicture.svgByteDecoderBuilder,
  //               weather.image,
  //             ),
  //             null);
  //       }
  //     },
  //     error: (message) {
  //       Get.snackbar('알림', message);
  //     },
  //   );
  // }

  void setSelectedEmoticon(EmoticonData emoticon) {
    selectedEmotion.value = emoticon;
  }

  String getWeatherNameKorean(String value) {
    switch (value) {
      case 'sunny':
        return '맑음';
      case 'rainy':
        return '비';
      case 'cloudy':
        return '흐림';
      case 'snow':
        return '눈';
      case 'windy':
        return '바람';
      case 'thunder':
        return '천둥';
      default:
        return '';
    }
  }
}
