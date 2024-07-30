import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/apis/emotion_stamp_api.dart';
import 'package:frontend/data/repository/emotion_stamp_repository/emotion_stamp_repository_impl.dart';
import 'package:frontend/data/repository/pop_up/pop_up_repository_impl.dart';
import 'package:frontend/di/dependency_injection.dart';
import 'package:frontend/domain/use_case/emotion_stamp_use_case/get_emotion_diary_use_case.dart';
import 'package:frontend/domain/use_case/pop_up/pop_up_use_case.dart';
import 'package:frontend/main.dart';
import 'package:frontend/providers/diary/provider/diary_provider.dart';
import 'package:frontend/providers/home/model/home_state.dart';
import 'package:frontend/providers/on_boarding/provider/on_boarding_provider.dart';
import 'package:frontend/ui/screen/birth_day/birth_day_screen.dart';
import 'package:frontend/ui/screen/diary/diary_screen.dart';
import 'package:frontend/ui/screen/emotion_stamp/emotion_stamp_screen.dart';
import 'package:frontend/ui/screen/profile/profile_screen.dart';
import 'package:frontend/utils/utils.dart';
import 'package:intl/intl.dart';

enum DiarySate {
  available, // 다이어리를 사용할 수 있는 상태
  alreadySaved, // 다이어리를 이미 저장해서 사용할 수 없는 상태
  writtenToday // 다이어리를 오늘 작성해서 사용할 수 없는 상태
}

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier(
    ref,
    PopUpUseCase(
      popUpRepository: PopUpRepositoryImpl(),
    ),
    GetEmotionStampUseCase(
      emotionStampRepository: EmotionStampRepositoryImpl(
        emotionStampApi: EmotionStampApi(
          dio: getDio(),
        ),
      ),
    ),
  );
});

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier(this.ref, this.popUpUseCase, this.getEmotionStampUseCase) : super(HomeState());

  final Ref ref;
  final PopUpUseCase popUpUseCase;
  final GetEmotionStampUseCase getEmotionStampUseCase;

  getLastBirthDayPopUpDate() async {
    state = state.copyWith(lastBirthDayPopupDate: await popUpUseCase.getLastBirthDayPopUpDate());

    if (state.lastBirthDayPopupDate != null) {
      DateTime now = DateTime.now();
      int timeDifference = now.difference(DateTime.parse(state.lastBirthDayPopupDate!)).inDays;

      if (timeDifference < 1) {
        state = state.copyWith(isNotBirthDayPopup: false);
      }
    }
  }

  Future<DiarySate> onItemTapped(int index) async {
    if (index == 0) {
      GlobalUtils.setAnalyticsCustomEvent('Click_BottomNav_EmotionCalendar');
    } else if (index == 1) {
      GlobalUtils.setAnalyticsCustomEvent('Click_BottomNav_WriteDiary');
    } else if (index == 2) {
      GlobalUtils.setAnalyticsCustomEvent('Click_BottomNav_Profile');
    }

    if (index == 1) {
      final result = await getEmotionStampUseCase.hasTodayDiary();
      final isTodayTempSave = await ref.watch(diaryProvider.notifier).getTempDiary(DateTime.now()) != null;

      if (result) {
        return DiarySate.writtenToday;
      }
      if (isTodayTempSave) {
        return DiarySate.alreadySaved;
      } else {
        navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => const DiaryScreen()));
      }
    }
    state = state.copyWith(selectedIndex: index);

    return DiarySate.available;
  }

  goToBirthPage() async {
    final now = DateTime.now();
    final dateFormat = DateFormat('yyyy-MM-dd');

    final birthday = dateFormat.parse('${ref.watch(onBoardingProvider).age}');

    final nowBirthday = DateTime(now.year, birthday.month, birthday.day);

    await getLastBirthDayPopUpDate();

    if (state.isNotBirthDayPopup && dateFormat.format(nowBirthday) == dateFormat.format(now)) {
      await navigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (context) => BirthDayScreen(
            name: ref.watch(onBoardingProvider).nickname,
          ),
        ),
      );
    }
  }

  void setSelectedIndex(int index) {
    state = state.copyWith(selectedIndex: index);
  }

  void setIsNotBirthDayPopup(bool isNotBirthDayPopup) {
    state = state.copyWith(isNotBirthDayPopup: isNotBirthDayPopup);
  }

  List<Widget> widgetList = const [
    EmotionStampScreen(),
    DiaryScreen(),
    ProfileScreen(),
  ];
}
