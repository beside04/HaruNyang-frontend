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

  Rx<String> worldViewTopic = "".obs;

  List<String> worldViewTopicList = [
    '하루냥은 고양이 숲에서 왔어요. 고양이 숲은 지구와 연결되어 있는 고양이들의 공간이에요.',
    '하루냥은 고양이 숲에서 왔어요. 고양이 숲의 날씨는 지구 친구들의 감정에 영향을 받아요.',
    '하루냥은 고양이 숲에서 왔어요. 고양이 숲에는 비가 많이와요.',
    '하루냥은 고양이 숲에서 왔어요. 지구의 사람들이 슬퍼하면 고양이 숲에 비가 온답니다.',
    '하루냥이 제일 좋아하는 음식은 붕어빵이에요.',
    '하루냥은 연잎을 우산으로 써요.',
    '하루냥은 택배박스 안에서 살고 있어요.',
    '하루냥이 좋아하는 과일은 수박이에요',
    '하루냥은 주황색을 좋아해요.',
    '하루냥은 지구의 chatGPT를 통해서 지구어를 통역해요.',
    '하루냥은 추운 겨울날 택배 박스를 타고 인간세계로 왔어요.',
    '붕어빵처럼 따뜻한 마음씨를 지닌 하루냥의 한 마디를 들어보세요!',
    '하루냥은 팥 붕어빵을 좋아해요.',
  ];

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
          _weekOfMonthForSimple(DateTime.parse(diaries[i].targetDate));
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

  // 월 주차. (단순하게 1일이 1주차 시작).
  String _weekOfMonthForSimple(DateTime date) {
    // 월의 첫번째 날짜.
    DateTime firstDay = DateTime(date.year, date.month, 1);

    // 월중에 첫번째 월요일인 날짜.
    DateTime firstMonday = firstDay
        .add(Duration(days: (DateTime.monday + 7 - firstDay.weekday) % 7));

    // 첫번째 날짜와 첫번째 월요일인 날짜가 동일한지 판단.
    // 동일할 경우: 1, 동일하지 않은 경우: 2 를 마지막에 더한다.
    final bool isFirstDayMonday = firstDay == firstMonday;

    final different = _calculateDaysBetween(from: firstMonday, to: date);

    // 주차 계산.
    int weekOfMonth = (different / 7 + (isFirstDayMonday ? 1 : 2)).toInt();

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
    }
    return "";
  }

  // D-Day 계산.
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

  void getRandomWorldViewTopic() {
    int randomNumber = Random().nextInt(worldViewTopicList.length);

    worldViewTopic.value = worldViewTopicList[randomNumber];
  }
}
