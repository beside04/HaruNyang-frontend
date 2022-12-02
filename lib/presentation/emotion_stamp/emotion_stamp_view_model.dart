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

  bool isToday(day) {
    return day.day == nowDate.value.day && day.month == nowDate.value.month;
  }

  bool isDateClicked(day) {
    return day.day == selectedCalendarDate.value.day &&
        day.month == selectedCalendarDate.value.month;
  }

  Map<DateTime, dynamic> tempEventSource = {
    DateTime.utc(2022, 11, 20): [TempEvent(eventTitle: 'test', icon: '😢')],
    DateTime.utc(2022, 11, 21): [TempEvent(eventTitle: 'test1', icon: '😅')],
    DateTime.utc(2022, 11, 22): [TempEvent(eventTitle: 'test2', icon: '🥲')],
    DateTime.utc(2022, 11, 26): [TempEvent(eventTitle: 'test3', icon: '😍')],
    DateTime.utc(2022, 11, 28): [TempEvent(eventTitle: 'test4', icon: '🥺')],
  };
}
