import 'package:flutter/widgets.dart';
import 'package:frontend/main_view_model.dart';
import 'package:frontend/presentation/diary/diary_screen.dart';
import 'package:frontend/presentation/emotion_stamp/emotion_stamp_screen.dart';
import 'package:frontend/presentation/profile/profile_screen.dart';
import 'package:get/get.dart';

class HomeViewModel extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Get.find<MainViewModel>().getMyInformation();
  }

  RxInt selectedIndex = 0.obs;

  void onItemTapped(int index) {
    selectedIndex.value = index;
  }

  List<Widget> widgetList = const [
    EmotionStampScreen(),
    DiaryScreen(),
    ProfileScreen(),
  ];
}
