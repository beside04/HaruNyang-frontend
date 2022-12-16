import 'package:get/get.dart';

class TempEvent {
  final String eventTitle;
  final String icon;

  TempEvent({
    required this.eventTitle,
    required this.icon,
  });
}

class EmotionStampViewModel extends GetxController {
  var focusedCalendarDate = DateTime.now().obs;
  var selectedCalendarDate = DateTime.now().obs;
  final nowDate = DateTime.now().obs;
  final isCalendar = true.obs;
  final currentPageCount = 250.obs;
  final itemPageCount = 500.obs;

  final controllerTempCount = 0.obs;

  // final pageController

  bool isToday(day) {
    return day.day == nowDate.value.day &&
        day.month == nowDate.value.month &&
        day.year == nowDate.value.year;
  }

  bool isDateClicked(day) {
    return day.day == selectedCalendarDate.value.day &&
        day.month == selectedCalendarDate.value.month &&
        day.year == selectedCalendarDate.value.year;
  }

  // 월 주차. (단순하게 1일이 1주차 시작).
  int weekOfMonthForSimple(DateTime date) {
    // 월의 첫번째 날짜.
    DateTime _firstDay = DateTime(date.year, date.month, 1);

    // 월중에 첫번째 월요일인 날짜.
    DateTime _firstMonday = _firstDay
        .add(Duration(days: (DateTime.monday + 7 - _firstDay.weekday) % 7));

    // 첫번째 날짜와 첫번째 월요일인 날짜가 동일한지 판단.
    // 동일할 경우: 1, 동일하지 않은 경우: 2 를 마지막에 더한다.
    final bool isFirstDayMonday = _firstDay == _firstMonday;

    final _different = calculateDaysBetween(from: _firstMonday, to: date);

    // 주차 계산.
    int _weekOfMonth = (_different / 7 + (isFirstDayMonday ? 1 : 2)).toInt();
    return _weekOfMonth;
  }

  // D-Day 계산.
  int calculateDaysBetween({required DateTime from, required DateTime to}) {
    return (to.difference(from).inHours / 24).round();
  }

  Map<DateTime, List<TempEvent>> tempEventSource = {
    DateTime.utc(2022, 11, 4): [
      TempEvent(
        eventTitle:
            'rkskekakd sjn kasnkdasnkdnajkndasjkndasjkndsjk jkasdnkjasnjkadn',
        icon:
            'https://firebasestorage.googleapis.com/v0/b/dark-room-84532.appspot.com/o/suprise.svg?alt=media',
      )
    ],
    DateTime.utc(2022, 11, 12): [
      TempEvent(
        eventTitle: '가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사',
        icon:
            'https://firebasestorage.googleapis.com/v0/b/dark-room-84532.appspot.com/o/suprise.svg?alt=media',
      )
    ],
    DateTime.utc(2022, 11, 20): [
      TempEvent(
        eventTitle: 'test',
        icon:
            'https://firebasestorage.googleapis.com/v0/b/dark-room-84532.appspot.com/o/suprise.svg?alt=media',
      )
    ],
    DateTime.utc(2022, 11, 21): [
      TempEvent(
        eventTitle: 'test1',
        icon:
            'https://firebasestorage.googleapis.com/v0/b/dark-room-84532.appspot.com/o/suprise.svg?alt=media',
      )
    ],
    DateTime.utc(2022, 11, 22): [
      TempEvent(
        eventTitle: 'test2',
        icon:
            'https://firebasestorage.googleapis.com/v0/b/dark-room-84532.appspot.com/o/suprise.svg?alt=media',
      )
    ],
    DateTime.utc(2022, 11, 26): [
      TempEvent(
        eventTitle: 'test3',
        icon:
            'https://firebasestorage.googleapis.com/v0/b/dark-room-84532.appspot.com/o/suprise.svg?alt=media',
      )
    ],
    DateTime.utc(2022, 11, 28): [
      TempEvent(
        eventTitle: 'test4',
        icon:
            'https://firebasestorage.googleapis.com/v0/b/dark-room-84532.appspot.com/o/happy.svg?alt=media',
      )
    ],
  };
}
