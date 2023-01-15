import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
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
  final RxBool isOnKeyboard = false.obs;
  final pickedFile = Rx<XFile?>(null);
  final croppedFile = Rx<CroppedFile?>(null);
  final cropQualityImage = Rx<File?>(null);
  final networkImage = Rx<String?>(null);
  bool isUpdated = false;

  late Rx<StreamSubscription<bool>?> keyboardSubscription =
      Rx<StreamSubscription<bool>?>(null);

  @override
  void onInit() {
    super.onInit();
    diaryEditingController.addListener(() {
      diaryValue.value = diaryEditingController.text;
    });

    var keyboardVisibilityController = KeyboardVisibilityController();

    keyboardSubscription.value =
        keyboardVisibilityController.onChange.listen((bool visible) {
      isOnKeyboard.value = visible;
    });
  }

  @override
  void onClose() {
    diaryEditingController.dispose();
    keyboardSubscription.value?.cancel();
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
}
