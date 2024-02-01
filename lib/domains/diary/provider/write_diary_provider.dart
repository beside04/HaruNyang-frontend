import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/domain/model/diary/diary_data.dart';
import 'package:frontend/domain/model/topic/topic_data.dart';
import 'package:frontend/domains/diary/model/write_diary_state.dart';
import 'package:frontend/ui/components/toast.dart';

final animationControllerProvider = StateProvider<AnimationController?>((ref) => null);
final cropQualityImageProvider = StateProvider<File?>((ref) => null);
final screenEntryTimeProvider = StateProvider<DateTime>((ref) => DateTime.now());

final writeDiaryProvider = StateNotifierProvider<WriteDiaryNotifier, WriteDiaryState>((ref) {
  return WriteDiaryNotifier(
    ref,
  );
});

class WriteDiaryNotifier extends StateNotifier<WriteDiaryState> {
  WriteDiaryNotifier(
    this.ref,
  ) : super(WriteDiaryState());

  final Ref ref;

  final diaryEditingController = TextEditingController();

  void onTextChanged() {
    state = state.copyWith(diaryValue: diaryEditingController.text);
  }

  void onTimerFinished() {
    state = state.copyWith(shouldShowWidget: true);
  }

  // Future<void> cropImage() async {
  //   final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 20);
  //   if (pickedImage != null) {
  //     await Future.delayed(Duration(milliseconds: 100));
  //     ref.watch(pickedFileProvider.notifier).state = pickedImage;
  //     await Future.delayed(Duration(milliseconds: 100));
  //   }
  //
  //   await Future.delayed(Duration(milliseconds: 100));
  //
  //   final bytes = await ref.watch(pickedFileProvider)!.readAsBytes();
  //   await Future.delayed(Duration(milliseconds: 100));
  //
  //   final kb = bytes.lengthInBytes / 1024;
  //   final directory = await getApplicationDocumentsDirectory();
  //
  //   if (kb > 200) {
  //     ref.watch(cropQualityImageProvider.notifier).state = await FlutterImageCompress.compressAndGetFile(
  //       ref.watch(pickedFileProvider)!.path,
  //       '${directory.path}/haruKitty.jpg',
  //       quality: 20,
  //     );
  //   } else {
  //     ref.watch(cropQualityImageProvider.notifier).state = await FlutterImageCompress.compressAndGetFile(
  //       ref.watch(pickedFileProvider)!.path,
  //       '${directory.path}/haruKitty.jpg',
  //       quality: 100,
  //     );
  //   }
  //   if (ref.watch(pickedFileProvider) != null) {
  //     CroppedFile? croppedImage = await ImageCropper().cropImage(
  //       sourcePath: ref.watch(cropQualityImageProvider)!.path,
  //       compressFormat: ImageCompressFormat.jpg,
  //       uiSettings: [
  //         AndroidUiSettings(
  //           toolbarTitle: 'Cropper',
  //           toolbarColor: kOrange200Color,
  //           toolbarWidgetColor: kWhiteColor,
  //           initAspectRatio: CropAspectRatioPreset.original,
  //           lockAspectRatio: false,
  //         ),
  //         IOSUiSettings(
  //           title: 'Cropper',
  //         ),
  //       ],
  //     );
  //     if (croppedImage != null) {
  //       ref.watch(croppedFileProvider.notifier).state = croppedImage;
  //     }
  //   }
  // }

  void setDiaryData(DiaryData diaryData) {
    diaryEditingController.text = diaryData.diaryContent;

    state = state.copyWith(diaryValueLength: diaryEditingController.text.length);
  }

  void getDefaultTopic(String emoticon) {
    switch (emoticon) {
      case "HAPPINESS":
        //기쁨
        state = state.copyWith(
          topic: const TopicData(
            id: 1,
            value: '오늘 가장 기쁜 일은\n 무엇이었나요?',
          ),
        );
        break;
      case "SURPRISED":
        //놀람
        state = state.copyWith(
          topic: const TopicData(
            id: 2,
            value: '오늘 가장 놀라운 일은\n 무엇이었나요?',
          ),
        );
        break;
      case "SADNESS":
        //슬픔
        state = state.copyWith(
          topic: const TopicData(
            id: 4,
            value: '오늘 가장 슬픈 일은\n 무엇이었나요?',
          ),
        );
        break;
      case "EXCITED":
        //신남
        state = state.copyWith(
          topic: const TopicData(
            id: 5,
            value: '오늘 가장 신난 일은\n 무엇이었나요?',
          ),
        );
        break;
      case "ANGRY":
        //화남
        state = state.copyWith(
          topic: const TopicData(
            id: 7,
            value: '오늘 가장 화난 일은\n 무엇이었나요?',
          ),
        );
        break;
      case "TIRED":
        //힘듬
        state = state.copyWith(
          topic: const TopicData(
            id: 8,
            value: '오늘 가장 힘들었던 일은\n 무엇이었나요?',
          ),
        );
        break;
      case "FLUTTER":
        //설렘
        state = state.copyWith(
          topic: const TopicData(
            id: 24,
            value: '오늘 가장 설레었던 일은\n 무엇이었나요?',
          ),
        );
        break;
      case "NEUTRAL, UNCERTAIN":
        state = state.copyWith(
          topic: const TopicData(
            id: 9,
            value: '오늘 가장 기억에 남는 일은\n 무엇이었나요?',
          ),
        );
        break;
      default:
        state = state.copyWith(
          topic: const TopicData(
            id: 9,
            value: '오늘 가장 기억에 남는 일은\n 무엇이었나요?',
          ),
        );
        break;
    }
  }

  void getRandomTopic() {
    int randomNumber = Random().nextInt(state.metaTopic.length);

    state = state.copyWith(
      topic: state.metaTopic[randomNumber],
    );

    state.metaTopic.removeAt(randomNumber);
  }

  void showSnackBar(String message, context) {
    toast(
      context: context,
      text: message,
      isCheckIcon: false,
      milliseconds: 1200,
    );
  }

  void setRandomImageNumber(int randomImageNumber) {
    state = state.copyWith(randomImageNumber: randomImageNumber);
  }

  void setDiaryValueLength(int diaryValueLength) {
    state = state.copyWith(diaryValueLength: diaryValueLength);
  }
}
