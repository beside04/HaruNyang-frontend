import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/apis/emotion_stamp_api.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/core/utils/utils.dart';
import 'package:frontend/data/data_source/local_data/auto_diary_save_data_source.dart';
import 'package:frontend/data/repository/emotion_stamp_repository/emotion_stamp_repository_impl.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/domain/model/diary/comment_data.dart';
import 'package:frontend/domain/model/diary/diary_card_data.dart';
import 'package:frontend/domain/model/diary/diary_detail_data.dart';
import 'package:frontend/domain/use_case/bookmark/bookmark_use_case.dart';
import 'package:frontend/domain/use_case/diary/delete_diary_use_case.dart';
import 'package:frontend/domain/use_case/diary/image_history_use_case.dart';
import 'package:frontend/domain/use_case/diary/save_diary_use_case.dart';
import 'package:frontend/domain/use_case/diary/update_diary_use_case.dart';
import 'package:frontend/domain/use_case/emotion_stamp_use_case/get_emotion_diary_use_case.dart';
import 'package:frontend/domains/diary/model/diary_state.dart';
import 'package:frontend/main.dart';
import 'package:frontend/ui/components/dialog_button.dart';
import 'package:frontend/ui/components/dialog_component.dart';
import 'package:frontend/ui/screen/diary/diary_detail/diary_detail_screen.dart';
import 'package:intl/intl.dart';

final diaryProvider = StateNotifierProvider<DiaryNotifier, DiaryState>((ref) {
  return DiaryNotifier(
    ref,
    GetEmotionStampUseCase(
      emotionStampRepository: EmotionStampRepositoryImpl(
        emotionStampApi: EmotionStampApi(
          dio: getDio(),
        ),
      ),
    ),
    SaveDiaryUseCase(
      diaryRepository: diaryRepository,
    ),
    UpdateDiaryUseCase(
      diaryRepository: diaryRepository,
    ),
    DeleteDiaryUseCase(
      diaryRepository: diaryRepository,
    ),
    BookmarkUseCase(
      bookmarkRepository: bookmarkRepository,
    ),
    ImageHistoryUseCase(
      diaryRepository: diaryRepository,
    ),
  );
});

class DiaryNotifier extends StateNotifier<DiaryState> {
  DiaryNotifier(this.ref, this.getEmotionStampUseCase, this.saveDiaryUseCase, this.updateDiaryUseCase, this.deleteDiaryUseCase, this.bookmarkUseCase, this.imageHistoryUseCase)
      : super(DiaryState(
          focusedStartDate: DateTime.now(),
          focusedEndDate: DateTime.now(),
          focusedCalendarDate: DateTime.now(),
          selectedCalendarDate: DateTime.now(),
        ));

  final Ref ref;

  final SaveDiaryUseCase saveDiaryUseCase;
  final UpdateDiaryUseCase updateDiaryUseCase;
  final DeleteDiaryUseCase deleteDiaryUseCase;
  final BookmarkUseCase bookmarkUseCase;
  final GetEmotionStampUseCase getEmotionStampUseCase;
  final ImageHistoryUseCase imageHistoryUseCase;

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

  Future<void> postImageHistory(String imageUrl) async {
    await imageHistoryUseCase(imageUrl);
  }

  // Future<void> getAllBookmarkData() async {
  //   int limit = 100;
  //   int page = 0;
  //   List<CommentData> bookmarkList = [];
  //   bool isEnd = false;
  //   while (true) {
  //     final result = await bookmarkUseCase.getBookmark(page, limit, null);
  //
  //     result.when(
  //       success: (data) {
  //         bookmarkList.addAll(data);
  //         if (data.length < limit) {
  //           isEnd = true;
  //         }
  //
  //         state = state.copyWith(
  //           bookmarkList: List.from(bookmarkList),
  //         );
  //       },
  //       error: (message) {
  //         isEnd = true;
  //       },
  //     );
  //     if (isEnd) {
  //       break;
  //     }
  //     page += 1;
  //   }
  //   state = state.copyWith(
  //     bookmarkList: bookmarkList,
  //   );
  // }

  Future<void> deleteBookmarkByBookmarkId(int bookmarkId, int index) async {
    final result = await bookmarkUseCase.deleteBookmark(bookmarkId);
    result.when(
      success: (data) async {
        // await getAllBookmarkData();

        updateBookmarkComments(index);
      },
      error: (message) {},
    );
  }

  updateBookmarkComments(int index) {
    if (state.diaryDetailData != null) {
      final updatedComments = List<CommentData>.from(state.diaryDetailData!.comments!)
        ..[index] = state.diaryDetailData!.comments![index].copyWith(isFavorite: !state.diaryDetailData!.comments![index].isFavorite);

      final updatedDiaryDetailData = state.diaryDetailData!.copyWith(comments: updatedComments);

      state = state.copyWith(diaryDetailData: updatedDiaryDetailData);
    }
  }

  Future<void> saveBookmark(int id, int index) async {
    final result = await bookmarkUseCase.saveBookmark(id);
    result.when(
      success: (data) async {
        // await getAllBookmarkData();

        updateBookmarkComments(index);
      },
      error: (message) {},
    );
  }

  Future<void> saveDiary(String date, DiaryDetailData diary) async {
    await AutoDiarySaveDataSource().saveDiary(date, diary);

    loadDiary(DateTime.parse(date));
  }

  void loadDiary(DateTime deleteDate) async {
    state = state.copyWith(isCalendarLoading: true);

    List<DiaryDetailData> filteredDiaryDataList = state.diaryDataList.where((diary) {
      // 날짜 비교를 위해 String으로 변환
      String diaryDate = DateFormat('yyyy-MM-dd').format(deleteDate);
      return !(diary.targetDate == diaryDate && diary.isAutoSave);
    }).toList();

    final autoDiaryData = await AutoDiarySaveDataSource().loadDiariesByMonth(
      DateFormat('yyyy').format(state.focusedStartDate),
      DateFormat('MM').format(state.focusedStartDate),
    );

    // Set을 사용하여 중복 제거
    final allDiaries = {...filteredDiaryDataList, ...autoDiaryData};
    List<DiaryDetailData> combinedList = allDiaries.toList();

    combinedList.sort((a, b) => b.targetDate.compareTo(a.targetDate));

    _makeDiaryCardDataList(combinedList);

    state = state.copyWith(
      isCalendarLoading: false,
      diaryDataList: combinedList,
    );
  }

  Future<String?> getTempDiary(DateTime dateTime) async {
    return await AutoDiarySaveDataSource().getDiary(DateFormat('yyyy-MM-dd').format(dateTime));
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

    final autoDiaryData = await AutoDiarySaveDataSource().loadDiariesByMonth(DateFormat('yyyy').format(state.focusedStartDate), DateFormat('MM').format(state.focusedStartDate));

    result.when(
      success: (result) {
        List<DiaryDetailData> combinedList = [...result, ...autoDiaryData];

        combinedList.sort((a, b) => b.targetDate.compareTo(a.targetDate));

        state = state.copyWith(
          diaryDataList: combinedList,
        );

        _makeDiaryCardDataList(combinedList);
      },
      error: (message) {
        // Get.snackbar('알림', '다이어리 목록을 불러오는데 실패했습니다.');
      },
    );

    state = state.copyWith(
      isCalendarLoading: false,
    );
  }

  void _makeDiaryCardDataList(List<DiaryDetailData> diaries) {
    List<DiaryCardData> diaryCardDataList = [];
    Map<String, List<DiaryDetailData>> weekName = {};
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

  Future<DiaryDetailData?> getDiaryDetail(id) async {
    print("ASDDSA");
    final result = await getDiaryDetailUseCase(id);

    return result.when(
      success: (data) async {
        await getEmotionStampList();
        state = state.copyWith(diaryDetailData: data);
        print("DSADSA");
        return data;
      },
      error: (message) {
        return null;
      },
    );
  }

  void setDiaryDetailData(DiaryDetailData? diaryDetailData) {
    state = state.copyWith(diaryDetailData: diaryDetailData);
  }

  Future<void> saveDiaryDetail(DiaryDetailData diary, DateTime date) async {
    final result = await saveDiaryUseCase(diary);

    result.when(
      success: (data) async {
        await getDiaryDetail(data.id);
        await AutoDiarySaveDataSource().deleteDiary(DateFormat('yyyy-MM-dd').format(date));

        if (data.comments![0].author == "harunyang") {
          navigatorKey.currentState!.push(
            MaterialPageRoute(
              builder: (context) => DiaryDetailScreen(
                diaryId: data.id!,
                date: date,
                // diaryData: diary,
                isNewDiary: true,
              ),
            ),
          );
        } else {
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
                      "lib/config/assets/images/character/character12.png",
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
                      navigatorKey.currentState!.push(
                        MaterialPageRoute(
                          builder: (context) => DiaryDetailScreen(
                            diaryId: data.id!,
                            date: date,
                            // diaryData: diary,
                            isNewDiary: true,
                          ),
                        ),
                      );
                    },
                    backgroundColor: kOrange200Color,
                    textStyle: kHeader4Style.copyWith(color: kWhiteColor),
                  ),
                ],
              );
            },
          );
        }
      },
      error: (message) async {
        saveDiary(date.toString(), diary);

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
                    "lib/config/assets/images/character/haru_error_case.png",
                    width: 120.w,
                    height: 120.h,
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Text(
                    "잠시 후 다시 시도해주세요.",
                    style: kHeader3Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Text(
                    "하루냥이 잠깐 낮잠자고 있어요...",
                    style: kHeader6Style.copyWith(color: Theme.of(context).colorScheme.textSubtitle),
                  ),
                ],
              ),
              actionContent: [
                DialogButton(
                  title: "알겠어요",
                  onTap: () async {
                    navigatorKey.currentState!.pop();
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

  Future<void> updateDiaryDetail(DiaryDetailData diary, DateTime date) async {
    final result = await updateDiaryUseCase(diary);

    result.when(
      success: (data) async {
        await getDiaryDetail(data.id);
        await AutoDiarySaveDataSource().deleteDiary(DateFormat('yyyy-MM-dd').format(date));

        if (data.comments![0].author == "harunyang") {
          navigatorKey.currentState!.push(
            MaterialPageRoute(
              builder: (context) => DiaryDetailScreen(
                diaryId: data.id!,
                date: date,
                // diaryData: diary,
                isNewDiary: true,
              ),
            ),
          );
        } else {
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
                      "lib/config/assets/images/character/character12.png",
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
                      navigatorKey.currentState!.push(
                        MaterialPageRoute(
                          builder: (context) => DiaryDetailScreen(
                            diaryId: data.id!,
                            date: date,
                            // diaryData: diary,
                            isNewDiary: true,
                          ),
                        ),
                      );
                    },
                    backgroundColor: kOrange200Color,
                    textStyle: kHeader4Style.copyWith(color: kWhiteColor),
                  ),
                ],
              );
            },
          );
        }
      },
      error: (message) {
        saveDiary(date.toString(), diary);

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
                    "lib/config/assets/images/character/haru_error_case.png",
                    width: 120.w,
                    height: 120.h,
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Text(
                    "잠시 후 다시 시도해주세요.",
                    style: kHeader3Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Text(
                    "하루냥이 잠깐 낮잠자고 있어요...",
                    style: kHeader6Style.copyWith(color: Theme.of(context).colorScheme.textSubtitle),
                  ),
                ],
              ),
              actionContent: [
                DialogButton(
                  title: "알겠어요",
                  onTap: () async {
                    navigatorKey.currentState!.pop();
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
}
