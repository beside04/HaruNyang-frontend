import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/domain/use_case/social_login_use_case/kakao_login_use_case.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class DiaryViewModel extends GetxController {
  final KakaoLoginUseCase kakaoLoginUseCase;

  DiaryViewModel({
    required this.kakaoLoginUseCase,
  });

  final pickedFile = Rx<XFile?>(null);
  final croppedFile = Rx<CroppedFile?>(null);

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
