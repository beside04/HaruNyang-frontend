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
    getEmoticonData();
    getWeatherData();
  }

  //final weatherStatus = Rx<Weather?>(null);

  // final emotionStatus = Rx<Emotion?>(null);
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
    int limit = getEmoticonLimitCount;
    int page = 0;
    final result = await getEmoticonUseCase(limit, page);

    result.when(
      success: (data) {
        emoticonDataList.value = data;
        // for (final emoticon in data) {
        //   await precachePicture(
        //       NetworkPicture(
        //         SvgPicture.svgByteDecoderBuilder,
        //         emoticon.emoticon,
        //       ),
        //       null);
        // }
      },
      error: (message) {
        Get.snackbar('알림', message);
      },
    );
  }

  Future<void> getWeatherData() async {
    final result = await getWeatherUseCase();

    result.when(
      success: (data) {
        weatherDataList.value = data;
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
