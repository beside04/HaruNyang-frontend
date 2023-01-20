import 'package:flutter/foundation.dart';
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
  }) {
    getMonthStartEndData();
  }

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

    //이미지 파일이 있다면 이미지 파일 업로드 먼저 실행
    if (imageFile != null) {
      final image = await fileUpload(imageFile);
      _state.value = state.value.copyWith(
        networkImage: image,
      );
    } else if (diary.images.isNotEmpty) {
      _state.value = state.value.copyWith(
        networkImage: diary.images.first,
      );
    }

    //명언 받아오기
    await getWiseSayingList(diary.emotion.id!, diary.diaryContent);

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

  Future<void> getWiseSayingList(int emoticonId, String content) async {
    final result = await getWiseSayingUseCase(emoticonId, content);

    await result.when(
      success: (result) async {
        if (result.isEmpty) {
          await getRandomWiseSayingList(emoticonId);
        } else {
          _state.value = state.value.copyWith(
            wiseSayingList: List.from(result),
          );
        }
      },
      error: (message) {
        Get.snackbar('알림', '명언을 불러오는데 실패했습니다.');
      },
    );
  }

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

  void toggleBookmark(WiseSayingData wiseSayingData) {
    final index = state.value.wiseSayingList.indexOf(wiseSayingData);
    final tempWiseSayingList = wiseSayingData.copyWith(
      isBookmarked: !wiseSayingData.isBookmarked,
    );

    if (tempWiseSayingList.isBookmarked) {
      if (state.value.wiseSayingList[index].id != null) {
        bookmarkUseCase.saveBookmark(state.value.wiseSayingList[index].id!);
      }
    } else {
      if (state.value.wiseSayingList[index].id != null) {
        bookmarkUseCase.deleteBookmark(state.value.wiseSayingList[index].id!);
      }
    }
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
      },
      error: (message) {
        Get.snackbar('알림', '데이터를 불러오는데 실패했습니다.');
      },
    );

    _state.value = state.value.copyWith(
      isCalendarLoading: false,
    );
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
