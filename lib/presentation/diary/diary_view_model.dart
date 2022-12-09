import 'package:flutter/material.dart';
import 'package:frontend/config/theme/color_data.dart';
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
  final pickedFile = Rx<XFile?>(null);
  final croppedFile = Rx<CroppedFile?>(null);
  final nowDate = DateTime.now().obs;

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
