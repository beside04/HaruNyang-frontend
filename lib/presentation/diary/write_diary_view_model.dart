import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class WriteDiaryViewModel extends GetxController {
  final TextEditingController nicknameEditingController =
      TextEditingController();
  final RxString nicknameValue = ''.obs;
  final RxBool isOnKeyboard = false.obs;
  final pickedFile = Rx<XFile?>(null);
  final croppedFile = Rx<CroppedFile?>(null);

  late Rx<StreamSubscription<bool>?> keyboardSubscription =
      Rx<StreamSubscription<bool>?>(null);

  @override
  void onInit() {
    super.onInit();
    nicknameEditingController.addListener(() {
      nicknameValue.value = nicknameEditingController.text;
    });

    var keyboardVisibilityController = KeyboardVisibilityController();

    keyboardSubscription.value =
        keyboardVisibilityController.onChange.listen((bool visible) {
      isOnKeyboard.value = visible;
    });
  }

  @override
  void onClose() {
    nicknameEditingController.dispose();
    keyboardSubscription.value?.cancel();
    super.onClose();
  }

  Future<void> cropImage() async {
    if (pickedFile.value != null) {
      CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: pickedFile.value!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: kPrimary2Color,
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
}
