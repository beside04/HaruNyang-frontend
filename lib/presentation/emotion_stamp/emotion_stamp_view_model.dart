import 'package:get/get.dart';

class TempEvent {
  final String eventTitle;
  final String icon;

  TempEvent({required this.eventTitle, required this.icon});

  @override
  String toString() => eventTitle;
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

  Map<DateTime, dynamic> tempEventSource = {
    DateTime.utc(2022, 11, 20): [
      TempEvent(
          eventTitle: 'test',
          icon:
              'https://firebasestorage.googleapis.com/v0/b/dark-room-84532.appspot.com/o/suprise.svg?alt=media')
    ],
    DateTime.utc(2022, 11, 21): [
      TempEvent(
          eventTitle: 'test1',
          icon:
              'https://firebasestorage.googleapis.com/v0/b/dark-room-84532.appspot.com/o/suprise.svg?alt=media')
    ],
    DateTime.utc(2022, 11, 22): [
      TempEvent(
          eventTitle: 'test2',
          icon:
              'https://firebasestorage.googleapis.com/v0/b/dark-room-84532.appspot.com/o/suprise.svg?alt=media')
    ],
    DateTime.utc(2022, 11, 26): [
      TempEvent(
          eventTitle: 'test3',
          icon:
              'https://firebasestorage.googleapis.com/v0/b/dark-room-84532.appspot.com/o/suprise.svg?alt=media')
    ],
    DateTime.utc(2022, 11, 28): [
      TempEvent(
          eventTitle: 'test4',
          icon:
              'https://firebasestorage.googleapis.com/v0/b/dark-room-84532.appspot.com/o/happy.svg?alt=media')
    ],
    DateTime.utc(2022, 12, 16): [
      TempEvent(
          eventTitle: 'test4',
          icon:
              'https://firebasestorage.googleapis.com/v0/b/dark-room-84532.appspot.com/o/angry.svg?alt=media')
    ],
  };
}
