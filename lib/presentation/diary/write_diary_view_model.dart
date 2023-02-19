import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/domain/model/diary/diary_data.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class WriteDiaryViewModel extends GetxController {
  final TextEditingController diaryEditingController = TextEditingController();
  final RxString diaryValue = ''.obs;
  final pickedFile = Rx<XFile?>(null);
  final croppedFile = Rx<CroppedFile?>(null);
  final cropQualityImage = Rx<File?>(null);
  final networkImage = Rx<String?>(null);
  bool isUpdated = false;
  int randomImageNumber = 1;
  Rx<int> topicReset = 3.obs;
  Rx<String> topic = ''.obs;

  List<String> metaTopic = [
    '요즘 힘든 점이 있어요?\n',
    '고민거리가 뭐에요?\n',
    '오늘 점심은 뭘 먹었어요?\n',
    '다가오는 주말에 뭘 할거에요?\n',
    '오늘 가장 재밌는 일은 뭐였어요?\n',
    '오늘 어떤 커피를 먹었어요?\n',
    '무엇이 나를 힘들게 해요?\n',
    '무엇이 나를 설레게 해요?\n',
    '내일 하고 싶은게 뭐에요?\n',
    '요즘 자주 듣는 음악이 뭐에요?\n',
    '먹고 싶은 음식이 있나요?\n',
    '지금 받고 싶은 선물이 뭐에요?\n',
    '쉬는 날에 어디 가고 싶어요?\n',
  ];

  @override
  void onInit() {
    super.onInit();
    randomImageNumber = Random().nextInt(7) + 1;

    diaryEditingController.addListener(() {
      diaryValue.value = diaryEditingController.text;
    });
  }

  @override
  void onClose() {
    diaryEditingController.dispose();
    super.onClose();
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
    final pickedImage = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 20);
    if (pickedImage != null) {
      pickedFile.value = pickedImage;
    }
  }

  void clear() {
    pickedFile.value = null;
    croppedFile.value = null;
    networkImage.value = null;
  }

  void setDiaryData(DiaryData diaryData) {
    if (!isUpdated) {
      diaryEditingController.text = diaryData.diaryContent;
      networkImage.value = diaryData.images.isEmpty
          ? null
          : diaryData.images.first.isEmpty
              ? null
              : diaryData.images.first;

      isUpdated = true;
    }
  }


  void getDefaultTopic(int emoticonId) {
    switch (emoticonId) {
      case 1:
      //기쁨
        topic.value = '오늘 가장 기쁜 일은 \n무엇이었나요?';
        break;
      case 2:
      //놀람
        topic.value = '오늘 가장 놀라운 일은 \n무엇이었나요?';
        break;
      case 3:
      //당황
        topic.value = '오늘 가장 당황한 일은 \n무엇이었나요?';
        break;
      case 4:
      //슬픔
        topic.value = '오늘 가장 슬픈 일은 \n무엇이었나요?';
        break;
      case 5:
      //신남
        topic.value = '오늘 가장 신난 일은 \n무엇이었나요?';
        break;
      case 6:
      //우울
        topic.value = '오늘 가장 우울한 일은 \n무엇이었나요?';
        break;
      case 7:
      //화남
        topic.value = '오늘 가장 화난 일은 \n무엇이었나요?';
        break;
      case 8:
      //힘듬
        topic.value = '오늘 가장 힘든 일은 \n무엇이었나요?';
        break;
      default:
        topic.value = '오늘 가장 기억에 남는 일은 \n무엇이었나요?';
        break;
    }
  }

  void getRandomTopic() {
    int randomNumber = Random().nextInt(metaTopic.length);
    topicReset.value -= 1;
    String message = topicReset.value == 0
        ? '글감을 더 받을 수 없어요.'
        : '글감 제공 횟수가 ${topicReset.value}회 남았어요';

    showSnackBar(message);
    topic.value = metaTopic[randomNumber];
    metaTopic.removeAt(randomNumber);
  }

  void showSnackBar(String message) {
    Get.closeAllSnackbars();
    Get.snackbar(
      '알림',
      message,
      duration: const Duration(
        milliseconds: 1200,
      ),
      snackPosition: SnackPosition.BOTTOM,
      animationDuration: const Duration(
        milliseconds: 0,
      ),
      margin: const EdgeInsets.symmetric(
        vertical: 50,
        horizontal: 30,
      ),
    );
  }
}
