import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/domain/use_case/emotion_stamp_use_case/get_emotion_diary_use_case.dart';
import 'package:frontend/domain/use_case/pop_up/pop_up_use_case.dart';
import 'package:frontend/global_controller/on_boarding/on_boarding_controller.dart';
import 'package:frontend/main.dart';
import 'package:frontend/presentation/birth_day/birth_day_screen.dart';
import 'package:frontend/presentation/components/dialog_button.dart';
import 'package:frontend/presentation/components/dialog_component.dart';
import 'package:frontend/presentation/diary/diary_screen.dart';
import 'package:frontend/presentation/emotion_stamp/emotion_stamp_screen.dart';
import 'package:frontend/presentation/login/login_screen.dart';
import 'package:frontend/presentation/profile/profile_screen.dart';
import 'package:frontend/res/constants.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:store_redirect/store_redirect.dart';

import '../../core/utils/utils.dart';

class HomeViewModel extends GetxController {
  final GetEmotionStampUseCase getEmotionStampUseCase;
  final PopUpUseCase popUpUseCase;

  HomeViewModel({
    required this.getEmotionStampUseCase,
    required this.popUpUseCase,
  });

  RxInt selectedIndex = 0.obs;
  RxBool isOpenPopup = false.obs;
  RxBool isNotBirthDayPopup = true.obs;

  String? lastPopupDate;
  String? lastBirthDayPopupDate;

  @override
  void onInit() {
    super.onInit();

    // 처음 가입한 유저라면 일기쓰기 화면으로 이동
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Get.arguments == null
          ? selectedIndex.value = 0
          : selectedIndex.value = Get.arguments['index'];

      Get.find<OnBoardingController>().state.value.age == '' ||
              Get.find<OnBoardingController>().state.value.age == null
          ? null
          : await goToBirthPage();
    });
  }

  getLastBirthDayPopUpDate() async {
    lastBirthDayPopupDate = await popUpUseCase.getLastBirthDayPopUpDate();

    if (lastBirthDayPopupDate != null) {
      DateTime now = DateTime.now();
      int timeDifference =
          now.difference(DateTime.parse(lastBirthDayPopupDate!)).inDays;

      if (timeDifference < 1) {
        isNotBirthDayPopup.value = false;
      }
    }
  }

  Future<bool> onItemTapped(int index) async {
    if (index == 0) {
      GlobalUtils.setAnalyticsCustomEvent('Click_BottomNav_EmotionCalendar');
    } else if (index == 1) {
      GlobalUtils.setAnalyticsCustomEvent('Click_BottomNav_WriteDiary');
    } else if (index == 2) {
      GlobalUtils.setAnalyticsCustomEvent('Click_BottomNav_Profile');
    }

    if (index == 1) {
      final result = await getEmotionStampUseCase.hasTodayDiary();

      if (result) {
        return false;
      } else {
        Get.to(() => const DiaryScreen());
      }
    }
    selectedIndex.value = index;

    return true;
  }

  goToBirthPage() async {
    final now = DateTime.now();
    final dateFormat = DateFormat('yyyy-MM-dd');

    final birthday =
        dateFormat.parse('${Get.find<OnBoardingController>().state.value.age}');

    final nowBirthday = DateTime(now.year, birthday.month, birthday.day);

    await getLastBirthDayPopUpDate();

    if (isNotBirthDayPopup.value &&
        dateFormat.format(nowBirthday) == dateFormat.format(now)) {
      await Get.to(
        () => BirthDayScreen(
          name: Get.find<OnBoardingController>().state.value.nickname,
        ),
      );
    }
  }

  List<Widget> widgetList = const [
    EmotionStampScreen(),
    DiaryScreen(),
    ProfileScreen(),
  ];
}
