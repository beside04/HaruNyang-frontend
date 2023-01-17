import 'package:flutter/widgets.dart';
import 'package:frontend/domain/use_case/emotion_stamp_use_case/get_emotion_diary_use_case.dart';
import 'package:frontend/global_controller/on_boarding/on_boarding_controller.dart';
import 'package:frontend/presentation/diary/diary_screen.dart';
import 'package:frontend/presentation/emotion_stamp/emotion_stamp_screen.dart';
import 'package:frontend/presentation/profile/profile_screen.dart';
import 'package:get/get.dart';

class HomeViewModel extends GetxController {
  final GetEmotionStampUseCase getEmotionStampUseCase;

  HomeViewModel({
    required this.getEmotionStampUseCase,
  });

  @override
  void onInit() {
    Get.find<OnBoardingController>().getMyInformation();
    super.onInit();
  }

  RxInt selectedIndex = 0.obs;

  Future<bool> onItemTapped(int index) async {
    if (index == 1) {
      final result = await getEmotionStampUseCase.hasTodayDiary();
      if (result) {
        return false;
      }
    }
    selectedIndex.value = index;
    return true;
  }

  List<Widget> widgetList = const [
    EmotionStampScreen(),
    DiaryScreen(),
    ProfileScreen(),
  ];
}
