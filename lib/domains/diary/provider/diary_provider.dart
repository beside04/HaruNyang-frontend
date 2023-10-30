import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/apis/emotion_stamp_api.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/core/result.dart';
import 'package:frontend/core/utils/utils.dart';
import 'package:frontend/data/repository/emotion_stamp_repository/emotion_stamp_repository_impl.dart';
import 'package:frontend/data/repository/pop_up/pop_up_repository_impl.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/domain/model/diary/comment_data.dart';
import 'package:frontend/domain/model/diary/diary_card_data.dart';
import 'package:frontend/domain/model/diary/diary_data.dart';
import 'package:frontend/domain/model/diary/diary_detail_data.dart';
import 'package:frontend/domain/repository/diary/diary_repository.dart';
import 'package:frontend/domain/use_case/bookmark/bookmark_use_case.dart';
import 'package:frontend/domain/use_case/diary/delete_diary_use_case.dart';
import 'package:frontend/domain/use_case/diary/save_diary_use_case.dart';
import 'package:frontend/domain/use_case/diary/update_diary_use_case.dart';
import 'package:frontend/domain/use_case/emotion_stamp_use_case/get_emotion_diary_use_case.dart';
import 'package:frontend/domain/use_case/pop_up/pop_up_use_case.dart';
import 'package:frontend/domains/diary/model/diary_state.dart';
import 'package:frontend/domains/home/model/home_state.dart';
import 'package:frontend/main.dart';
import 'package:frontend/ui/components/dialog_button.dart';
import 'package:frontend/ui/components/dialog_component.dart';
import 'package:frontend/ui/screen/diary/diary_detail/diary_detail_screen.dart';
import 'package:intl/intl.dart';

final diaryProvider = StateNotifierProvider<DiaryNotifier, DiaryState>((ref) {
  final diaryRepository = ref.watch(diaryRepositoryProvider);
  return DiaryNotifier(diaryRepository:diaryRepository);
});

class DiaryNotifier extends StateNotifier<DiaryState> {
  final DiaryRepository diaryRepository;
  DiaryNotifier({
    required this.diaryRepository,
  }) : super(DiaryState(
      focusedStartDate: DateTime.now(),
      focusedEndDate: DateTime.now(),
      focusedCalendarDate: DateTime.now(),
      selectedCalendarDate: DateTime.now(),
  ));



  // final Ref ref;

  // final SaveDiaryUseCase saveDiaryUseCase;
  // final UpdateDiaryUseCase updateDiaryUseCase;
  // final DeleteDiaryUseCase deleteDiaryUseCase;
  // final BookmarkUseCase bookmarkUseCase;
  // final GetEmotionStampUseCase getEmotionStampUseCase;

  Future<Result<DiaryDetailData>> saveDiary$ (DiaryData diary) async {
    try {
      DiaryData request = DiaryData(
          diaryContent: diary.diaryContent, feeling: diary.feeling, feelingScore: diary.feelingScore, weather: diary.weather, targetDate: diary.targetDate,
      );
      Result<DiaryDetailData> response = await diaryRepository.saveDiary(request);

      return Result.success(
          DiaryDetailData.fromJson(response.data),
      );
    } on DioError catch (e) {
      return Result.error(e.message);
    }
  }

  Future<Result<DiaryDetailData>> updateDiary$ (DiaryData diary) async {
    try {
      DiaryData request = DiaryData(
        diaryContent: diary.diaryContent, feeling: diary.feeling, feelingScore: diary.feelingScore, weather: diary.weather, targetDate: diary.targetDate,
      );
      Result<DiaryDetailData> response = await diaryRepository.updateDiary(request);

      return Result.success(
        DiaryDetailData.fromJson(response.data),
      );
    } on DioError catch (e) {
      return Result.error(e.message);
    }
  }

  Future<Result<bool>> deleteDiary$(int diaryId) async {
    try {

      var response = await diaryRepository.deleteDiary(diaryId);
      final bool resultData = response.data;

      if(resultData) {
        return const Result.success(true);
      } else {
        return const Result.error('일기 삭제가 실패 했습니다.');
      }

    } on DioError catch (e) {
      return Result.error(e.message);
    }
  }

  resetDiary() {
    state = state.copyWith(
      isLoading: true,
      networkImage: '',
      diary: null,
      wiseSayingList: [],
      isNote: false,
      diaryDetailData: null,
    );
  }

  Future<void> deleteDiary(int diaryID) async {
    await deleteDiaryUseCase(diaryID);
    getEmotionStampList();
  }

  Future<void> getAllBookmarkData() async {
    int limit = 100;
    int page = 0;
    List<CommentData> bookmarkList = [];
    bool isEnd = false;
    while (true) {
      final result = await bookmarkUseCase.getBookmark(page, limit);

      result.when(
        success: (data) {
          bookmarkList.addAll(data);
          if (data.length < limit) {
            isEnd = true;
          }

          state = state.copyWith(
            bookmarkList: List.from(bookmarkList),
          );
        },
        error: (message) {
          isEnd = true;
        },
      );
      if (isEnd) {
        break;
      }
      page += 1;
    }
    state = state.copyWith(
      bookmarkList: bookmarkList,
    );
  }

  Future<void> deleteBookmarkByBookmarkId(int bookmarkId, int index) async {
    final result = await bookmarkUseCase.deleteBookmark(bookmarkId);
    result.when(
      success: (data) async {
        await getAllBookmarkData();

        updateBookmarkComments(index);
      },
      error: (message) {},
    );
  }

  updateBookmarkComments(int index) {
    if (state.diaryDetailData != null) {
      final updatedComments = List<CommentData>.from(state.diaryDetailData!.comments)
        ..[index] = state.diaryDetailData!.comments[index].copyWith(isFavorite: !state.diaryDetailData!.comments[index].isFavorite);

      final updatedDiaryDetailData = state.diaryDetailData!.copyWith(comments: updatedComments);

      state = state.copyWith(diaryDetailData: updatedDiaryDetailData);
    }
  }

  Future<void> saveBookmark(int id, int index) async {
    final result = await bookmarkUseCase.saveBookmark(id);
    result.when(
      success: (data) async {
        await getAllBookmarkData();

        updateBookmarkComments(index);
      },
      error: (message) {},
    );
  }

  Future<void> getEmotionStampList() async {
    state = state.copyWith(
      isCalendarLoading: true,
    );

    getMonthStartEndData();

    final result = await getEmotionStampUseCase(
      DateFormat('yyyy-MM-dd').format(state.focusedStartDate),
      DateFormat('yyyy-MM-dd').format(state.focusedEndDate),
    );

    result.when(
      success: (result) {
        result.sort((a, b) {
          return b.targetDate.compareTo(a.targetDate);
        });

        state = state.copyWith(
          diaryDataList: result,
        );

        _makeDiaryCardDataList(result);
      },
      error: (message) {
        // Get.snackbar('알림', '다이어리 목록을 불러오는데 실패했습니다.');
      },
    );

    state = state.copyWith(
      isCalendarLoading: false,
    );
  }

  void _makeDiaryCardDataList(List<DiaryData> diaries) {
    List<DiaryCardData> diaryCardDataList = [];
    Map<String, List<DiaryData>> weekName = {};
    for (int i = 0; i < diaries.length; i++) {
      String title = _weekOfMonthForCalendar(DateTime.parse(diaries[i].targetDate));
      if (weekName.containsKey(title)) {
        weekName[title]!.add(diaries[i]);
      } else {
        weekName[title] = [diaries[i]];
      }
    }
    for (var title in weekName.keys) {
      diaryCardDataList.add(DiaryCardData(title: title, diaryDataList: weekName[title]!));
    }
    state = state.copyWith(
      diaryCardDataList: diaryCardDataList,
    );
  }

  String _weekOfMonthForCalendar(DateTime date) {
    DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);
    DateTime lastDayOfMonth = DateTime(date.year, date.month + 1, 0); // 다음 달의 0일은 현재 달의 마지막 날입니다.

    // 시작 날짜와 끝 날짜가 튀어나와 있는지 확인
    bool isFirstDayStickingOut = firstDayOfMonth.weekday > DateTime.monday;
    bool isLastDayStickingOut = lastDayOfMonth.weekday < DateTime.sunday;

    // 첫 날짜가 튀어나와 있으면 첫 주는 그 날 하나만으로 구성됩니다.
    if (isFirstDayStickingOut && date.day == 1) {
      return "첫";
    }

    // 마지막 날짜가 튀어나와 있으면 마지막 주는 그 날 하나만으로 구성됩니다.
    if (isLastDayStickingOut && date.day == lastDayOfMonth.day) {
      return "여섯";
    }

    // 첫 날짜가 튀어나와 있다면 1을 더해 첫 주를 고려합니다.
    int offset = isFirstDayStickingOut ? 1 : 0;

    // 날짜를 주로 변환
    int weekOfMonth = ((date.day + offset - 1) / 7 + 1).toInt();

    switch (weekOfMonth) {
      case 1:
        return "첫";
      case 2:
        return "두";
      case 3:
        return "세";
      case 4:
        return "네";
      case 5:
        return "다섯";
      case 6:
        return "여섯";
    }
    return "";
  }

  int _calculateDaysBetween({required DateTime from, required DateTime to}) {
    return (to.difference(from).inHours / 24).round();
  }

  void getMonthStartEndData() {
    state = state.copyWith(
      focusedStartDate: DateTime(
        state.focusedCalendarDate.year,
        state.focusedCalendarDate.month,
        1,
      ),
      focusedEndDate: DateTime(
        state.focusedCalendarDate.year,
        state.focusedCalendarDate.month + 1,
        0,
      ),
    );
  }

  void initPage() {
    onPageChanged(DateTime.now());
    state = state.copyWith(
      selectedCalendarDate: DateTime.now(),
    );
  }

  void onPageChanged(DateTime day) {
    state = state.copyWith(
      focusedCalendarDate: day,
    );
    getMonthStartEndData();
    getEmotionStampList();
  }

  void setFocusDay(DateTime day) {
    state = state.copyWith(
      focusedCalendarDate: day,
    );
  }

  void toggleCalendarMode() {
    if (state.isCalendar) {
      GlobalUtils.setAnalyticsCustomEvent('Click_Toggle_CalendarToList');
    } else {
      GlobalUtils.setAnalyticsCustomEvent('Click_Toggle_ListToCalendar');
    }

    state = state.copyWith(
      isCalendar: !state.isCalendar,
    );
  }

  void setSelectedCalendarDate(DateTime date) {
    state = state.copyWith(
      selectedCalendarDate: date,
    );
  }

  void setIsNote(bool isNote) {
    state = state.copyWith(
      isNote: isNote,
    );
  }

  Future<void> getDiaryDetail(id) async {
    final result = await getDiaryDetailUseCase(id);

    result.when(
      success: (data) async {
        await getEmotionStampList();
        state = state.copyWith(diaryDetailData: data);
      },
      error: (message) {},
    );
  }

  void setDiaryDetailData(DiaryDetailData? diaryDetailData) {
    state = state.copyWith(diaryDetailData: diaryDetailData);
  }

  Future<void> saveDiaryDetail(diary, date) async {
    final result = await saveDiaryUseCase(diary);

    result.when(
      success: (data) async {
        await getDiaryDetail(data.id);

        navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (context) => DiaryDetailScreen(
              diaryId: data.id,
              date: date,
              diaryData: diary,
              isNewDiary: true,
            ),
          ),
        );
      },
      error: (message) {
        showDialog(
          barrierDismissible: true,
          context: navigatorKey.currentContext!,
          builder: (context) {
            return DialogComponent(
              titlePadding: EdgeInsets.zero,
              title: "",
              content: Column(
                children: [
                  Image.asset(
                    "lib/config/assets/images/character/update1.png",
                    width: 120.w,
                    height: 120.h,
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Text(
                    "하루냥이 잠깐 낮잠을 자고 있어요.",
                    style: kHeader3Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Text(
                    "대신 재밌는 명언을 추천해드릴게요.",
                    style: kHeader6Style.copyWith(color: Theme.of(context).colorScheme.textSubtitle),
                  ),
                ],
              ),
              actionContent: [
                DialogButton(
                  title: "알겠어요",
                  onTap: () async {
                    navigatorKey.currentState!.pop();
                  },
                  backgroundColor: kOrange200Color,
                  textStyle: kHeader4Style.copyWith(color: kWhiteColor),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> updateDiaryDetail(diary, date) async {
    final result = await updateDiaryUseCase(diary);

    result.when(
      success: (data) async {
        await getDiaryDetail(data.id);

        navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (context) => DiaryDetailScreen(
              diaryId: data.id,
              date: date,
              diaryData: diary,
              isNewDiary: true,
            ),
          ),
        );
      },
      error: (message) {},
    );
  }
}
