import 'package:flutter/material.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/domain/model/diary/emotion_data.dart';
import 'package:frontend/domain/model/diary/weather_data.dart';
import 'package:frontend/domain/use_case/social_login_use_case/kakao_login_use_case.dart';
import 'package:frontend/presentation/diary/components/emotion_modal.dart';
import 'package:frontend/presentation/diary/components/weather_modal.dart';
import 'package:frontend/res/constants.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class DiaryViewModel extends GetxController
    with GetSingleTickerProviderStateMixin {
  final KakaoLoginUseCase kakaoLoginUseCase;
  late AnimationController animationController;

  DiaryViewModel({
    required this.kakaoLoginUseCase,
  });

  final weatherStatus = Rx<Weather?>(null);
  final emotionStatus = Rx<Emotion?>(null);
  final pickedFile = Rx<XFile?>(null);
  final croppedFile = Rx<CroppedFile?>(null);
  final nowDate = DateTime.now().obs;
  final numberValue = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  List<Widget> stackChildren = <Widget>[
    const EmotionModal(),
    const WeatherModal(),
  ];

  void swapStackChildren() {
    stackChildren = [
      const WeatherModal(),
      const EmotionModal(),
    ];
    update();
  }

  void swapStackChildren2() {
    stackChildren = [
      const EmotionModal(),
      const WeatherModal(),
    ];
    update();
  }

  List<WeatherData> weatherDataList = [
    WeatherData(
      name: "맑음",
      icon: 'lib/config/assets/images/diary/weather/sunny.svg',
      value: 'sunny',
    ),
    WeatherData(
      name: "흐림",
      icon: 'lib/config/assets/images/diary/weather/cloudy.svg',
      value: 'cloudy',
    ),
    WeatherData(
      name: "비",
      icon: 'lib/config/assets/images/diary/weather/rainy.svg',
      value: 'rainy',
    ),
    WeatherData(
      name: "눈",
      icon: 'lib/config/assets/images/diary/weather/snow.svg',
      value: 'snow',
    ),
    WeatherData(
      name: "바람",
      icon: 'lib/config/assets/images/diary/weather/windy.svg',
      value: 'windy',
    ),
    WeatherData(
      name: "번개",
      icon: 'lib/config/assets/images/diary/weather/thunder.svg',
      value: 'thunder',
    ),
  ].obs;

  List<EmotionData> emotionDataList = [
    EmotionData(
      name: "기뻐",
      icon: 'lib/config/assets/images/diary/emotion/happy.svg',
      value: 'happy',
    ),
    EmotionData(
      name: "슬퍼",
      icon: 'lib/config/assets/images/diary/emotion/sad.svg',
      value: 'sad',
    ),
    EmotionData(
      name: "화나",
      icon: 'lib/config/assets/images/diary/emotion/angry.svg',
      value: 'angry',
    ),
    EmotionData(
      name: "신나",
      icon: 'lib/config/assets/images/diary/emotion/enjoy.svg',
      value: 'enjoy',
    ),
    EmotionData(
      name: "힘들어",
      icon: 'lib/config/assets/images/diary/emotion/tired.svg',
      value: 'tired',
    ),
    EmotionData(
      name: "놀라워",
      icon: 'lib/config/assets/images/diary/emotion/suprise2.svg',
      value: 'tired',
    ),
    EmotionData(
      name: "그저그래",
      icon: 'lib/config/assets/images/diary/emotion/soso.svg',
      value: 'soso',
    ),
    EmotionData(
      name: "당황스러워",
      icon: 'lib/config/assets/images/diary/emotion/embarrassment.svg',
      value: 'embarrassment',
    ),
    EmotionData(
      name: "설레",
      icon: 'lib/config/assets/images/diary/emotion/good.svg',
      value: 'good',
    ),
  ].obs;

  Future<void> cropImage() async {
    if (pickedFile.value != null) {
      var croppedImage = await ImageCropper().cropImage(
        sourcePath: pickedFile.value!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: kPrimaryColor,
            toolbarWidgetColor: kWhiteColor,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      );
      if (croppedImage != null) {
        croppedFile.value = croppedImage;
      }
    }
  }

  Future<void> uploadImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      pickedFile.value = pickedImage;
    }
  }

  void clear() {
    pickedFile.value = null;
    croppedFile.value = null;
  }

  Future<void> logout() async {
    await kakaoLoginUseCase.logout();
  }
}
