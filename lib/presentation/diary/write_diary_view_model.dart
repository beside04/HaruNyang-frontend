import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/core/utils/utils.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/domain/model/diary/diary_data.dart';
import 'package:frontend/domain/model/topic/topic_data.dart';
import 'package:frontend/global_controller/diary/diary_controller.dart';
import 'package:frontend/presentation/components/toast.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

class WriteDiaryViewModel extends GetxController with GetSingleTickerProviderStateMixin {
  final String emotion;
  final DiaryData? diaryData;
  WriteDiaryViewModel({
    required this.emotion,
    this.diaryData,
  });

  final Rx<TextEditingController> diaryEditingController = TextEditingController().obs;
  final RxString diaryValue = ''.obs;
  final pickedFile = Rx<XFile?>(null);
  final croppedFile = Rx<CroppedFile?>(null);
  final cropQualityImage = Rx<File?>(null);
  final networkImage = Rx<String?>(null);
  Rx<int> diaryValueLength = 0.obs;
  late AnimationController animationController;

  final firebaseImageUrl = Rx<String>('');

  bool isUpdated = false;
  int randomImageNumber = 1;
  Rx<TopicData> topic = TopicData(
    id: 0,
    value: '',
  ).obs;

  Timer? timer;
  Rx<bool> shouldShowWidget = false.obs;

  List<TopicData> metaTopic = [
    TopicData(
      id: 9,
      value: '오늘 가장 기억에 남는 일은\n 무엇이었나요?',
    ),
    TopicData(
      id: 10,
      value: '요즘 힘든 점이\n 있어요?',
    ),
    TopicData(
      id: 11,
      value: '고민거리가\n 뭐에요?',
    ),
    TopicData(
      id: 12,
      value: '오늘 점심은\n 뭘 먹었어요?',
    ),
    TopicData(
      id: 13,
      value: '다가오는 주말에\n 뭘 할거에요?',
    ),
    TopicData(
      id: 14,
      value: '오늘 가장 재밌는 일은\n 뭐였어요?',
    ),
    TopicData(
      id: 15,
      value: '오늘 어떤 커피를\n 먹었어요?',
    ),
    TopicData(
      id: 16,
      value: '무엇이 나를\n 힘들게 해요?',
    ),
    TopicData(
      id: 17,
      value: '무엇이 나를\n 설레게 해요?',
    ),
    TopicData(
      id: 18,
      value: '내일 하고\n 싶은게 뭐에요?',
    ),
    TopicData(
      id: 19,
      value: '요즘 자주 듣는\n 음악이 뭐에요?',
    ),
    TopicData(
      id: 20,
      value: '먹고 싶은 음식이\n 있나요?',
    ),
    TopicData(
      id: 21,
      value: '지금 받고 싶은\n 선물이 뭐에요?',
    ),
    TopicData(
      id: 22,
      value: '쉬는 날에\n 어디 가고 싶어요?',
    ),
  ];

  DateTime screenEntryTime = DateTime.now();

  @override
  void onInit() {
    super.onInit();
    randomImageNumber = Random().nextInt(7) + 1;
    animationController = AnimationController(vsync: this);

    diaryEditingController.value.addListener(onTextChanged);

    timer = Timer(const Duration(seconds: 5), _onTimerFinished);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getDefaultTopic(emotion);

      if (diaryData != null) {
        setDiaryData(diaryData!);
      }
    });
  }

  @override
  void onClose() {
    diaryEditingController.value.dispose();
    animationController.dispose();
    diaryEditingController.value.removeListener(onTextChanged);
    timer?.cancel();

    super.onClose();

    DateTime screenExitTime = DateTime.now();
    Duration stayDuration = screenExitTime.difference(screenEntryTime);

    // Firebase Analytics에 체류시간 로깅
    GlobalUtils.setAnalyticsCustomEvent('stay_duration', {
      'screen': "Screen_Event_WriteDiary_WritePage",
      'duration': stayDuration.inSeconds,
    });
  }

  void onTextChanged() {
    diaryValue.value = diaryEditingController.value.text;
    if (timer?.isActive ?? false) {
      timer?.cancel();
      timer = Timer(const Duration(seconds: 5), _onTimerFinished);
    }
  }

  void _onTimerFinished() {
    shouldShowWidget.value = true;
  }

  Future<void> cropImage() async {
    final bytes = await pickedFile.value!.readAsBytes();
    final kb = bytes.lengthInBytes / 1024;
    final directory = await getApplicationDocumentsDirectory();

    if (kb > 200) {
      cropQualityImage.value = await FlutterImageCompress.compressAndGetFile(
        pickedFile.value!.path,
        '${directory.path}/haruKitty.jpg',
        quality: 20,
      );
    } else {
      cropQualityImage.value = await FlutterImageCompress.compressAndGetFile(
        pickedFile.value!.path,
        '${directory.path}/haruKitty.jpg',
        quality: 100,
      );
    }
    if (pickedFile.value != null) {
      CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: cropQualityImage.value!.path,
        compressFormat: ImageCompressFormat.jpg,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: kOrange200Color,
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
    final socialId = await tokenUseCase.getSocialId();

    File file = File(croppedFile.value!.path);

    try {
      // Use the user's UID and the current timestamp to create a unique path for each image.
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

      await FirebaseStorage.instance.ref('uploads/$socialId/$timestamp.png').putFile(file);

      String downloadURL = await FirebaseStorage.instance.ref('uploads/$socialId/$timestamp.png').getDownloadURL();

      firebaseImageUrl.value = downloadURL;
    } on FirebaseException {
      Get.snackbar('알림', '이미지 업로드에 실패하였습니다.');
      // e.g, e.code == 'canceled'
    }
  }

  Future<void> selectDeviceImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 20);
    if (pickedImage != null) {
      pickedFile.value = pickedImage;
    }
  }

  void clear() {
    pickedFile.value = null;
    croppedFile.value = null;
    networkImage.value = null;
    Get.find<DiaryController>().diaryDetailData.value = Get.find<DiaryController>().diaryDetailData.value!.copyWith(image: "");
  }

  void setDiaryData(DiaryData diaryData) {
    if (!isUpdated) {
      diaryEditingController.value.text = diaryData.diaryContent;

      isUpdated = true;
    }
  }

  void getDefaultTopic(String emoticon) {
    switch (emoticon) {
      case "HAPPINESS":
        //기쁨
        topic.value = TopicData(
          id: 1,
          value: '오늘 가장 기쁜 일은\n 무엇이었나요?',
        );
        break;
      case "SURPRISED":
        //놀람
        topic.value = TopicData(
          id: 2,
          value: '오늘 가장 놀라운 일은\n 무엇이었나요?',
        );
        break;
      case "SADNESS":
        //슬픔
        topic.value = TopicData(
          id: 4,
          value: '오늘 가장 슬픈 일은\n 무엇이었나요?',
        );
        break;
      case "EXCITED":
        //신남
        topic.value = TopicData(
          id: 5,
          value: '오늘 가장 신난 일은\n 무엇이었나요?',
        );
        break;
      case "ANGRY":
        //화남
        topic.value = TopicData(
          id: 7,
          value: '오늘 가장 화난 일은\n 무엇이었나요?',
        );
        break;
      case "TIRED":
        //힘듬
        topic.value = TopicData(
          id: 8,
          value: '오늘 가장 힘들었던 일은\n 무엇이었나요?',
        );
        break;
      case "FLUTTER":
        //설렘
        topic.value = TopicData(
          id: 24,
          value: '오늘 가장 설레었던 일은\n 무엇이었나요?',
        );
        break;
      case "NEUTRAL, UNCERTAIN":
        topic.value = TopicData(
          id: 9,
          value: '오늘 가장 기억에 남는 일은\n 무엇이었나요?',
        );
        break;
      default:
        topic.value = TopicData(
          id: 9,
          value: '오늘 가장 기억에 남는 일은\n 무엇이었나요?',
        );
        break;
    }
  }

  void getRandomTopic() {
    int randomNumber = Random().nextInt(metaTopic.length);

    topic.value = metaTopic[randomNumber];
    metaTopic.removeAt(randomNumber);
  }

  void showSnackBar(String message, context) {
    toast(
      context: context,
      text: message,
      isCheckIcon: false,
      milliseconds: 1200,
    );
  }
}
