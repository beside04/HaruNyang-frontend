import 'dart:math';

import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/domain/model/diary/comment_data.dart';
import 'package:frontend/domain/model/diary/diary_card_data.dart';
import 'package:frontend/domain/model/diary/diary_data.dart';
import 'package:frontend/domain/model/diary/diary_detail_data.dart';
import 'package:frontend/domain/use_case/bookmark/bookmark_use_case.dart';
import 'package:frontend/domain/use_case/diary/delete_diary_use_case.dart';
import 'package:frontend/domain/use_case/diary/save_diary_use_case.dart';
import 'package:frontend/domain/use_case/diary/update_diary_use_case.dart';
import 'package:frontend/domain/use_case/emotion_stamp_use_case/get_emotion_diary_use_case.dart';
import 'package:frontend/global_controller/diary/diary_state.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../core/utils/utils.dart';

class DiaryController extends GetxController {
  final SaveDiaryUseCase saveDiaryUseCase;
  final UpdateDiaryUseCase updateDiaryUseCase;
  final DeleteDiaryUseCase deleteDiaryUseCase;
  final BookmarkUseCase bookmarkUseCase;
  final GetEmotionStampUseCase getEmotionStampUseCase;

  DiaryController({
    required this.saveDiaryUseCase,
    required this.updateDiaryUseCase,
    required this.deleteDiaryUseCase,
    required this.bookmarkUseCase,
    required this.getEmotionStampUseCase,
  });

  final Rx<DiaryState> _state = DiaryState(
    focusedStartDate: DateTime.now(),
    focusedEndDate: DateTime.now(),
    focusedCalendarDate: DateTime.now(),
    selectedCalendarDate: DateTime.now(),
  ).obs;

  Rx<DiaryState> get state => _state;
  int currentPageCount = 250;
  RxBool isNote = false.obs;

  @override
  void onInit() {
    initPage();
    super.onInit();
  }

  resetDiary() {
    _state.value = state.value.copyWith(
      isLoading: true,
      networkImage: '',
      diary: null,
      wiseSayingList: [],
    );

    isNote.value = false;

    Get.find<DiaryController>().diaryDetailData.value = null;
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

          _state.value = state.value.copyWith(
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
    _state.value = state.value.copyWith(
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
    if (diaryDetailData.value != null) {
      final updatedComments =
          List<CommentData>.from(diaryDetailData.value!.comments)
            ..[index] = diaryDetailData.value!.comments[index].copyWith(
                isFavorite: !diaryDetailData.value!.comments[index].isFavorite);

      final updatedDiaryDetailData =
          diaryDetailData.value!.copyWith(comments: updatedComments);

      diaryDetailData.value = updatedDiaryDetailData;
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
    _state.value = state.value.copyWith(
      isCalendarLoading: true,
    );

    getMonthStartEndData();

    final result = await getEmotionStampUseCase(
      DateFormat('yyyy-MM-dd').format(state.value.focusedStartDate),
      DateFormat('yyyy-MM-dd').format(state.value.focusedEndDate),
    );

    result.when(
      success: (result) {
        result.sort((a, b) {
          return b.targetDate.compareTo(a.targetDate);
        });

        _state.value = state.value.copyWith(
          diaryDataList: result,
        );

        _makeDiaryCardDataList(result);
      },
      error: (message) {
        // Get.snackbar('알림', '다이어리 목록을 불러오는데 실패했습니다.');
      },
    );

    _state.value = state.value.copyWith(
      isCalendarLoading: false,
    );
  }

  void _makeDiaryCardDataList(List<DiaryData> diaries) {
    List<DiaryCardData> diaryCardDataList = [];
    Map<String, List<DiaryData>> weekName = {};
    for (int i = 0; i < diaries.length; i++) {
      String title =
          _weekOfMonthForCalendar(DateTime.parse(diaries[i].targetDate));
      if (weekName.containsKey(title)) {
        weekName[title]!.add(diaries[i]);
      } else {
        weekName[title] = [diaries[i]];
      }
    }
    for (var title in weekName.keys) {
      diaryCardDataList
          .add(DiaryCardData(title: title, diaryDataList: weekName[title]!));
    }
    _state.value = state.value.copyWith(
      diaryCardDataList: diaryCardDataList,
    );
  }

  String _weekOfMonthForCalendar(DateTime date) {
    DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);
    DateTime lastDayOfMonth =
        DateTime(date.year, date.month + 1, 0); // 다음 달의 0일은 현재 달의 마지막 날입니다.

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
    _state.value = state.value.copyWith(
      focusedStartDate: DateTime(
        state.value.focusedCalendarDate.year,
        state.value.focusedCalendarDate.month,
        1,
      ),
      focusedEndDate: DateTime(
        state.value.focusedCalendarDate.year,
        state.value.focusedCalendarDate.month + 1,
        0,
      ),
    );
  }

  void initPage() {
    onPageChanged(DateTime.now());
    _state.value = state.value.copyWith(
      selectedCalendarDate: DateTime.now(),
    );
  }

  void onPageChanged(DateTime day) {
    _state.value = state.value.copyWith(
      focusedCalendarDate: day,
    );
    getMonthStartEndData();
    getEmotionStampList();
  }

  void setFocusDay(DateTime day) {
    _state.value = state.value.copyWith(
      focusedCalendarDate: day,
    );
  }

  void toggleCalendarMode() {
    if (_state.value.isCalendar) {
      GlobalUtils.setAnalyticsCustomEvent('Click_Toggle_CalendarToList');
    } else {
      GlobalUtils.setAnalyticsCustomEvent('Click_Toggle_ListToCalendar');
    }

    _state.value = state.value.copyWith(
      isCalendar: !state.value.isCalendar,
    );
  }

  void setSelectedCalendarDate(DateTime date) {
    _state.value = state.value.copyWith(
      selectedCalendarDate: date,
    );
  }

  final diaryDetailData = Rx<DiaryDetailData?>(null);

  Future<void> getDiaryDetail(id) async {
    final result = await getDiaryDetailUseCase(id);

    result.when(
      success: (data) async {
        await getEmotionStampList();
        diaryDetailData.value = data;
      },
      error: (message) {},
    );
  }
}
