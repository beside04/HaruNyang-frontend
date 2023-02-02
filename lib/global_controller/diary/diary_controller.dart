import 'package:flutter/foundation.dart';
import 'package:frontend/domain/model/bookmark/bookmark_data.dart';
import 'package:frontend/domain/model/diary/diary_card_data.dart';
import 'package:frontend/domain/model/diary/diary_data.dart';
import 'package:frontend/domain/model/wise_saying/wise_saying_data.dart';
import 'package:frontend/domain/use_case/bookmark/bookmark_use_case.dart';
import 'package:frontend/domain/use_case/diary/delete_diary_use_case.dart';
import 'package:frontend/domain/use_case/diary/save_diary_use_case.dart';
import 'package:frontend/domain/use_case/diary/update_diary_use_case.dart';
import 'package:frontend/domain/use_case/emotion_stamp_use_case/get_emotion_diary_use_case.dart';
import 'package:frontend/domain/use_case/upload/file_upload_use_case.dart';
import 'package:frontend/domain/use_case/wise_saying_use_case/get_wise_saying_use_case.dart';
import 'package:frontend/global_controller/diary/diary_state.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';

class DiaryController extends GetxController {
  final FileUploadUseCase fileUploadUseCase;
  final GetWiseSayingUseCase getWiseSayingUseCase;
  final SaveDiaryUseCase saveDiaryUseCase;
  final UpdateDiaryUseCase updateDiaryUseCase;
  final DeleteDiaryUseCase deleteDiaryUseCase;
  final BookmarkUseCase bookmarkUseCase;
  final GetEmotionStampUseCase getEmotionStampUseCase;

  DiaryController({
    required this.fileUploadUseCase,
    required this.getWiseSayingUseCase,
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

  Future<void> saveDiary(
      DiaryData diary, CroppedFile? imageFile, DateTime writeDate) async {
    //데이터 초기화
    _state.value = state.value.copyWith(
      isLoading: true,
      networkImage: '',
      diary: null,
      wiseSayingList: [],
    );

    await Future.delayed(const Duration(seconds: 2));

    //명언 받아오기
    await getWiseSayingList();

    //새로운 diary Data
    final newDiary = diary.copyWith(
      images: [state.value.networkImage],
      wiseSayings: state.value.wiseSayingList,
      createTime: DateFormat('yyyy-MM-dd').format(writeDate),
    );

    if (diary.id != null) {
      //다이어리 업데이트
      await updateDiaryUseCase(
        newDiary,
      );
      _state.value = state.value.copyWith(
        diary: newDiary,
      );
    } else {
      //다이어리 저장
      final result = await saveDiaryUseCase(newDiary);
      result.when(
        success: (diaryId) {
          _state.value = state.value.copyWith(
            diary: newDiary.copyWith(id: diaryId),
          );
        },
        error: (message) {
          Get.snackbar(
            '알림',
            message,
          );
        },
      );
    }

    getEmotionStampList();
    _state.value = state.value.copyWith(
      isLoading: false,
    );
  }

  // Future<void> saveDiary(
  //     DiaryData diary, CroppedFile? imageFile, DateTime writeDate) async {
  //   //데이터 초기화
  //   _state.value = state.value.copyWith(
  //     isLoading: true,
  //     networkImage: '',
  //     diary: null,
  //     wiseSayingList: [],
  //   );
  //
  //   //이미지 파일이 있다면 이미지 파일 업로드 먼저 실행
  //   if (imageFile != null) {
  //     final image = await fileUpload(imageFile);
  //     _state.value = state.value.copyWith(
  //       networkImage: image,
  //     );
  //   } else if (diary.images.isNotEmpty) {
  //     _state.value = state.value.copyWith(
  //       networkImage: diary.images.first,
  //     );
  //   }
  //
  //   //명언 받아오기
  //   await getWiseSayingList(diary.emotion.id!, diary.diaryContent);
  //
  //   //새로운 diary Data
  //   final newDiary = diary.copyWith(
  //     images: [state.value.networkImage],
  //     wiseSayings: state.value.wiseSayingList,
  //     createTime: DateFormat('yyyy-MM-dd').format(writeDate),
  //   );
  //
  //   if (diary.id != null) {
  //     //다이어리 업데이트
  //     await updateDiaryUseCase(
  //       newDiary,
  //     );
  //     _state.value = state.value.copyWith(
  //       diary: newDiary,
  //     );
  //   } else {
  //     //다이어리 저장
  //     final result = await saveDiaryUseCase(newDiary);
  //     result.when(
  //       success: (diaryId) {
  //         _state.value = state.value.copyWith(
  //           diary: newDiary.copyWith(id: diaryId),
  //         );
  //       },
  //       error: (message) {
  //         Get.snackbar(
  //           '알림',
  //           message,
  //         );
  //       },
  //     );
  //   }
  //
  //   getEmotionStampList();
  //   _state.value = state.value.copyWith(
  //     isLoading: false,
  //   );
  // }

  Future<void> deleteDiary(String diaryID) async {
    await deleteDiaryUseCase(diaryID);
    getEmotionStampList();
  }

  void setCalendarData(DiaryData diaryData) {
    String networkImage =
        (diaryData.images.isNotEmpty) ? diaryData.images.first : '';

    _state.value = state.value.copyWith(
      isLoading: false,
      diary: diaryData,
      wiseSayingList: diaryData.wiseSayings,
      networkImage: networkImage,
    );
  }

  Future<String> fileUpload(CroppedFile imageFile) async {
    String imageResult = '';
    Uint8List bytes = await imageFile.readAsBytes();
    String fileName = imageFile.path.split('/').last;
    final result = await fileUploadUseCase(bytes, fileName);
    result.when(
      success: (fileResult) {
        imageResult = fileResult;
      },
      error: (message) {},
    );
    return imageResult;
  }

  Future<void> getWiseSayingList() async {
    List<WiseSayingData> wiseSayingData = [
      WiseSayingData(
          author: "하루냥",
          message: "Mock Data Mock Data Mock Data Mock Data Mock Data "),
      WiseSayingData(author: "하루냥2", message: "2초뒤에 나오는 명언"),
    ];

    _state.value = state.value.copyWith(
      wiseSayingList: List.from(wiseSayingData),
    );
  }

  // Future<void> getWiseSayingList(int emoticonId, String content) async {
  //   final result = await getWiseSayingUseCase(emoticonId, content);
  //
  //   await result.when(
  //     success: (result) async {
  //       if (result.isEmpty) {
  //         await getRandomWiseSayingList(emoticonId);
  //       } else {
  //         _state.value = state.value.copyWith(
  //           wiseSayingList: List.from(result),
  //         );
  //       }
  //     },
  //     error: (message) {
  //       Get.snackbar('알림', '명언을 불러오는데 실패했습니다.');
  //     },
  //   );
  // }

  Future<void> getRandomWiseSayingList(int emoticonId) async {
    final result = await getWiseSayingUseCase.getRandomWiseSaying(emoticonId);

    result.when(
      success: (result) {
        _state.value = state.value.copyWith(
          wiseSayingList: List.from(result),
        );
      },
      error: (message) {
        Get.snackbar('알림', '명언을 불러오는데 실패했습니다.');
      },
    );
  }

  Future<void> getAllBookmarkData() async {
    int limit = 100;
    int page = 0;
    List<BookmarkData> bookmarkList = [];
    bool isEnd = false;
    while (true) {
      final result = await bookmarkUseCase.getBookmark(page, limit);
      result.when(
        success: (data) {
          bookmarkList.addAll(data);
          if (data.length < limit) {
            isEnd = true;
          }
        },
        error: (message) {},
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

  Future<void> deleteBookmarkByBookmarkId(int bookmarkId) async {
    final result = await bookmarkUseCase.deleteBookmark(bookmarkId);
    result.when(
      success: (data) {
        getAllBookmarkData();
      },
      error: (message) {},
    );
  }

  Future<void> deleteBookmarkByWiseSaying(WiseSayingData wiseSaying) async {
    int bookmarkId = _getBookmarkId(wiseSaying);
    if (bookmarkId == -1) {
      return;
    }
    final result = await bookmarkUseCase.deleteBookmark(bookmarkId);
    result.when(
      success: (data) {
        getAllBookmarkData();
      },
      error: (message) {},
    );
  }

  int _getBookmarkId(WiseSayingData wiseSayingData) {
    final bookmarkList = state.value.bookmarkList;
    int bookmarkId = -1;
    for (int i = 0; i < bookmarkList.length; i++) {
      if (bookmarkList[i].wiseSaying.id == wiseSayingData.id) {
        bookmarkId = bookmarkList[i].id;
      }
    }
    return bookmarkId;
  }

  Future<void> saveBookmark(WiseSayingData wiseSayingData) async {
    if (!isBookmarked(wiseSayingData.id!)) {
      if (wiseSayingData.id != null) {
        await bookmarkUseCase.saveBookmark(wiseSayingData.id!);
        getAllBookmarkData();
      }
    }
  }

  bool isBookmarked(int wiseSayingId) {
    bool result = false;
    final List<BookmarkData> bookmarkList = state.value.bookmarkList;
    for (int i = 0; i < bookmarkList.length; i++) {
      if (bookmarkList[i].wiseSaying.id == wiseSayingId) {
        result = true;
        break;
      }
    }
    return result;
  }

  Future<void> getEmotionStampList() async {
    _state.value = state.value.copyWith(
      isCalendarLoading: true,
    );

    final result = await getEmotionStampUseCase(
      DateFormat('yyyy-MM-dd').format(state.value.focusedStartDate),
      DateFormat('yyyy-MM-dd').format(state.value.focusedEndDate),
    );

    result.when(
      success: (result) {
        result.sort((a, b) {
          return b.writtenAt.compareTo(a.writtenAt);
        });

        _state.value = state.value.copyWith(
          diaryDataList: result,
        );
        _makeDiaryCardDataList(result);
      },
      error: (message) {
        Get.snackbar('알림', '데이터를 불러오는데 실패했습니다.');
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
          _weekOfMonthForSimple(DateTime.parse(diaries[i].writtenAt));
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
    _state.value = state.value.copyWith(
      isCalendar: !state.value.isCalendar,
    );
  }

  void setSelectedCalendarDate(DateTime date) {
    _state.value = state.value.copyWith(
      selectedCalendarDate: date,
    );
  }
}
