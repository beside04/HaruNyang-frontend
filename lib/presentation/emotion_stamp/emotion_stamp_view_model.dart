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
    getEmotionStampList();
  }

  var focusedCalendarDate = DateTime.now().obs;
  var selectedCalendarDate = DateTime.now().obs;
  final isCalendar = true.obs;
  final currentPageCount = 250.obs;
  final itemPageCount = 500.obs;
  final controllerTempCount = 0.obs;

  final RxBool isLoading = false.obs;
  Map<DateTime, List<DiaryData>> diaryCalendarDataList = {};
  Map<String, Object> diaryListDataList = {"key_ordered": [], "values": {}}.obs;
  var focusedStartDate = DateTime.now().obs;
  var focusedEndDate = DateTime.now().obs;

  bool isToday(day) {
    return day.day == DateTime.now().day &&
        day.month == DateTime.now().month &&
        day.year == DateTime.now().year;
  }

  bool isDay(day) {
    var nowDate = DateTime.now();

    return (nowDate.isAfter(day) || isToday(day));
  }

  bool isDateClicked(day) {
    return day.day == selectedCalendarDate.value.day &&
        day.month == selectedCalendarDate.value.month &&
        day.year == selectedCalendarDate.value.year;
  }

  // 월 주차. (단순하게 1일이 1주차 시작).
  static String weekOfMonthForSimple(DateTime date) {
    // 월의 첫번째 날짜.
    DateTime firstDay = DateTime(date.year, date.month, 1);

    // 월중에 첫번째 월요일인 날짜.
    DateTime firstMonday = firstDay
        .add(Duration(days: (DateTime.monday + 7 - firstDay.weekday) % 7));

    // 첫번째 날짜와 첫번째 월요일인 날짜가 동일한지 판단.
    // 동일할 경우: 1, 동일하지 않은 경우: 2 를 마지막에 더한다.
    final bool isFirstDayMonday = firstDay == firstMonday;

    final different = calculateDaysBetween(from: firstMonday, to: date);

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
  static int calculateDaysBetween(
      {required DateTime from, required DateTime to}) {
    return (to.difference(from).inHours / 24).round();
  }

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
        parsingListDate(result);
      },
      error: (message) {
        Get.snackbar('알림', '데이터를 불러오는데 실패했습니다.');
      },
    );
    _updateIsLoading(false);
  }

  parsingListDate(List<DiaryData> result) async {
    diaryListDataList = {"key_ordered": [], "values": {}}.obs;
    diaryCalendarDataList = {};

    result.sort((a, b) {
      return b.writtenAt.compareTo(a.writtenAt);
    });

    for (var data in result) {
      diaryCalendarDataList[DateTime(
        DateTime.parse(data.writtenAt).year,
        DateTime.parse(data.writtenAt).month,
        DateTime.parse(data.writtenAt).day,
      ).toUtc().add(const Duration(hours: 9))] = [data];

      var dateTime = weekOfMonthForSimple(DateTime.parse(data.writtenAt));

      if (!diaryListDataList["key_ordered"].toString().contains(dateTime)) {
        (diaryListDataList["key_ordered"] as List).add(dateTime);
        (diaryListDataList["values"] as Map)[dateTime] = [];
      }

      (diaryListDataList["values"] as Map)[dateTime].add(data);
    }
  }

  getMonthStartEndData() {
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
}
