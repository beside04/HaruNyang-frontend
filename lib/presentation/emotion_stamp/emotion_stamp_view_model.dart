import 'package:frontend/domain/model/diary/diary_data.dart';
import 'package:frontend/domain/use_case/emotion_stamp_use_case/get_emotion_diary_use_case.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EmotionStampViewModel extends GetxController {
  final GetEmotionStampUseCase getEmotionStampUseCase;

  EmotionStampViewModel({
    required this.getEmotionStampUseCase,
  });

  @override
  void onInit() {
    super.onInit();

    getMonthStartEndData();
  }

  final RxBool isCalendar = true.obs;
  final RxBool isLoading = false.obs;
  int currentPageCount = 250;

  Rx<DateTime> focusedCalendarDate = DateTime.now().obs;
  RxList<DiaryData> diaryDataList = <DiaryData>[].obs;

  Map<String, Object> diaryListDataList = {"key_ordered": [], "values": {}}.obs;
  var focusedStartDate = DateTime.now().obs;
  var focusedEndDate = DateTime.now().obs;
  DateTime selectedCalendarDate = DateTime.now();

  void _updateIsLoading(bool currentStatus) {
    isLoading.value = currentStatus;
  }

  Future<void> getEmotionStampList() async {
    _updateIsLoading(true);

    final result = await getEmotionStampUseCase(
      DateFormat('yyyy-MM-dd').format(focusedStartDate.value),
      DateFormat('yyyy-MM-dd').format(focusedEndDate.value),
    );

    result.when(
      success: (result) {
        result.sort((a, b) {
          return b.writtenAt.compareTo(a.writtenAt);
        });

        diaryDataList.value = result;
      },
      error: (message) {
        Get.snackbar('알림', '데이터를 불러오는데 실패했습니다.');
      },
    );
    _updateIsLoading(false);
  }

  void getMonthStartEndData() {
    focusedStartDate.value = DateTime(
      focusedCalendarDate.value.year,
      focusedCalendarDate.value.month,
      1,
    );

    focusedEndDate.value = DateTime(
      focusedCalendarDate.value.year,
      focusedCalendarDate.value.month + 1,
      0,
    );
  }

  void onPageChanged(DateTime day) {
    focusedCalendarDate.value = day;
    getMonthStartEndData();
    getEmotionStampList();
  }

  void setFocusDay(DateTime day) {
    focusedCalendarDate.value = day;
  }
}
