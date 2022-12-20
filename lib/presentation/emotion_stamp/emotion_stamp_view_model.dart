import 'package:frontend/domain/model/emotion_stamp/emotion_stamp_data.dart';
import 'package:frontend/domain/use_case/emotion_stamp_use_case/get_emotion_diary_use_case.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TempEvent {
  final String eventTitle;
  final String icon;

  TempEvent({
    required this.eventTitle,
    required this.icon,
  });
}

class EmotionStampViewModel extends GetxController {
  final GetEmotionStampUseCase getEmotionStampUseCase;

  EmotionStampViewModel({
    required this.getEmotionStampUseCase,
  });

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
        return "첫";
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

  List<EmotionStampData> emotionStampList = [];

  // final mockData = {
  //   "data": [
  //     {
  //       "id": "639ac3891fefd56d312b2fd7",
  //       "content": "test",
  //       "user_id": 2538859272,
  //       "emotion": {
  //         "id": 3,
  //         "image_url":
  //             "https://firebasestorage.googleapis.com/v0/b/dark-room-84532.appspot.com/o/happy.svg?alt=media",
  //         "value": "기쁨",
  //         "desc": "기쁨"
  //       },
  //       "emotion_index": 10,
  //       "wise_sayings": [],
  //       "weather": "rainy",
  //       "images": [
  //         "https://firebasestorage.googleapis.com/v0/b/dark-room-84532.appspot.com/o/4d3381fe-b44c-46df-949a-a665c44d0b08.file?generation=1671434470286103&alt=media"
  //       ],
  //       "created_at": "2022-12-11T15:49:45",
  //       "updated_at": "2022-12-15T15:49:45"
  //     },
  //     {
  //       "id": "639ac45f1fefd56d312b2fdb",
  //       "content": "test",
  //       "user_id": 2538859272,
  //       "emotion": {
  //         "id": 3,
  //         "image_url":
  //             "https://firebasestorage.googleapis.com/v0/b/dark-room-84532.appspot.com/o/happy.svg?alt=media",
  //         "value": "기쁨",
  //         "desc": "기쁨"
  //       },
  //       "emotion_index": 10,
  //       "wise_sayings": [],
  //       "weather": "rainy",
  //       "images": [
  //         "https://firebasestorage.googleapis.com/v0/b/dark-room-84532.appspot.com/o/4d3381fe-b44c-46df-949a-a665c44d0b08.file?generation=1671434470286103&alt=media"
  //       ],
  //       "created_at": "2022-12-19T15:53:19",
  //       "updated_at": "2022-12-15T15:53:19"
  //     },
  //     {
  //       "id": "639ac46e1fefd56d312b2fdc",
  //       "content": "test",
  //       "user_id": 2538859272,
  //       "emotion": {
  //         "id": 3,
  //         "image_url":
  //             "https://firebasestorage.googleapis.com/v0/b/dark-room-84532.appspot.com/o/happy.svg?alt=media",
  //         "value": "기쁨",
  //         "desc": "기쁨"
  //       },
  //       "emotion_index": 10,
  //       "wise_sayings": [],
  //       "weather": "rainy",
  //       "images": [],
  //       "created_at": "2022-12-22T15:53:34",
  //       "updated_at": "2022-12-15T15:53:34"
  //     },
  //     {
  //       "id": "639ac6ce1fefd56d312b2fde",
  //       "content": "test",
  //       "user_id": 2538859272,
  //       "emotion": {
  //         "id": 3,
  //         "image_url":
  //             "https://firebasestorage.googleapis.com/v0/b/dark-room-84532.appspot.com/o/happy.svg?alt=media",
  //         "value": "기쁨",
  //         "desc": "기쁨"
  //       },
  //       "emotion_index": 10,
  //       "wise_sayings": [],
  //       "weather": "rainy",
  //       "images": [],
  //       "created_at": "2022-12-27T16:03:42",
  //       "updated_at": "2022-12-15T16:03:42"
  //     },
  //     {
  //       "id": "639ac6dd1fefd56d312b2fdf",
  //       "content": "test",
  //       "user_id": 2538859272,
  //       "emotion": {
  //         "id": 3,
  //         "image_url":
  //             "https://firebasestorage.googleapis.com/v0/b/dark-room-84532.appspot.com/o/happy.svg?alt=media",
  //         "value": "기쁨",
  //         "desc": "기쁨"
  //       },
  //       "emotion_index": 50,
  //       "wise_sayings": [],
  //       "weather": "rainy",
  //       "images": [
  //         "https://firebasestorage.googleapis.com/v0/b/dark-room-84532.appspot.com/o/4d3381fe-b44c-46df-949a-a665c44d0b08.file?generation=1671434470286103&alt=media"
  //       ],
  //       "created_at": "2022-12-15T16:03:57",
  //       "updated_at": "2022-12-15T16:03:57"
  //     },
  //     {
  //       "id": "639ac8881fefd56d312b2fe0",
  //       "content": "test",
  //       "user_id": 2538859272,
  //       "emotion": {
  //         "id": 3,
  //         "image_url":
  //             "https://firebasestorage.googleapis.com/v0/b/dark-room-84532.appspot.com/o/happy.svg?alt=media",
  //         "value": "기쁨",
  //         "desc": "기쁨"
  //       },
  //       "emotion_index": 50,
  //       "wise_sayings": [
  //         {
  //           "id": 968,
  //           "author": "익명",
  //           "message": "죽음과 삶은 두 개의 한계이다. 두 개의 한계를 넘어선 저편에  하나의 무엇이 있다."
  //         }
  //       ],
  //       "weather": "rainy",
  //       "images": [],
  //       "created_at": "2022-12-15T16:11:04",
  //       "updated_at": "2022-12-15T16:11:04"
  //     }
  //   ],
  //   "status": 200,
  //   "code": "D002",
  //   "message": "일기 조회 성공"
  // };
  //
  // final nextMockData = {
  //   "data": [
  //     {
  //       "id": "639ac3891fefd56d312b2fd7",
  //       "content": "test",
  //       "user_id": 2538859272,
  //       "emotion": {
  //         "id": 3,
  //         "image_url":
  //             "https://firebasestorage.googleapis.com/v0/b/dark-room-84532.appspot.com/o/happy.svg?alt=media",
  //         "value": "기쁨",
  //         "desc": "기쁨"
  //       },
  //       "emotion_index": 10,
  //       "wise_sayings": [],
  //       "weather": "rainy",
  //       "images": [
  //         "https://firebasestorage.googleapis.com/v0/b/dark-room-84532.appspot.com/o/4d3381fe-b44c-46df-949a-a665c44d0b08.file?generation=1671434470286103&alt=media"
  //       ],
  //       "created_at": "2023-01-11T15:49:45",
  //       "updated_at": "2022-12-15T15:49:45"
  //     },
  //     {
  //       "id": "639ac45f1fefd56d312b2fdb",
  //       "content": "test",
  //       "user_id": 2538859272,
  //       "emotion": {
  //         "id": 3,
  //         "image_url":
  //             "https://firebasestorage.googleapis.com/v0/b/dark-room-84532.appspot.com/o/happy.svg?alt=media",
  //         "value": "기쁨",
  //         "desc": "기쁨"
  //       },
  //       "emotion_index": 10,
  //       "wise_sayings": [],
  //       "weather": "rainy",
  //       "images": [
  //         "https://firebasestorage.googleapis.com/v0/b/dark-room-84532.appspot.com/o/4d3381fe-b44c-46df-949a-a665c44d0b08.file?generation=1671434470286103&alt=media"
  //       ],
  //       "created_at": "2023-01-19T15:53:19",
  //       "updated_at": "2022-12-15T15:53:19"
  //     },
  //     {
  //       "id": "639ac6dd1fefd56d312b2fdf",
  //       "content": "test",
  //       "user_id": 2538859272,
  //       "emotion": {
  //         "id": 3,
  //         "image_url":
  //             "https://firebasestorage.googleapis.com/v0/b/dark-room-84532.appspot.com/o/happy.svg?alt=media",
  //         "value": "기쁨",
  //         "desc": "기쁨"
  //       },
  //       "emotion_index": 50,
  //       "wise_sayings": [],
  //       "weather": "rainy",
  //       "images": [],
  //       "created_at": "2023-01-16T16:03:57",
  //       "updated_at": "2022-12-15T16:03:57"
  //     },
  //     {
  //       "id": "639ac8881fefd56d312b2fe0",
  //       "content": "test",
  //       "user_id": 2538859272,
  //       "emotion": {
  //         "id": 3,
  //         "image_url":
  //             "https://firebasestorage.googleapis.com/v0/b/dark-room-84532.appspot.com/o/happy.svg?alt=media",
  //         "value": "기쁨",
  //         "desc": "기쁨"
  //       },
  //       "emotion_index": 50,
  //       "wise_sayings": [
  //         {
  //           "id": 968,
  //           "author": "익명",
  //           "message": "죽음과 삶은 두 개의 한계이다. 두 개의 한계를 넘어선 저편에  하나의 무엇이 있다."
  //         }
  //       ],
  //       "weather": "rainy",
  //       "images": [
  //         "https://firebasestorage.googleapis.com/v0/b/dark-room-84532.appspot.com/o/4d3381fe-b44c-46df-949a-a665c44d0b08.file?generation=1671434470286103&alt=media"
  //       ],
  //       "created_at": "2023-01-15T16:11:04",
  //       "updated_at": "2022-12-15T16:11:04"
  //     }
  //   ],
  //   "status": 200,
  //   "code": "D002",
  //   "message": "일기 조회 성공"
  // };

  // ignore: prefer_typing_uninitialized_variables
  var data;
  // ignore: prefer_typing_uninitialized_variables
  var addResultList;
  final RxBool isLoading = false.obs;
  Map<String, Object> dataResult = {"key_ordered": [], "values": {}}.obs;
  var focusedStartDate = DateTime.now().obs;
  var focusedEndDate = DateTime.now().obs;

  void _updateIsLoading(bool currentStatus) {
    isLoading.value = currentStatus;
  }

  Future<void> getEmotionStampList() async {
    final result = await getEmotionStampUseCase(
      DateFormat('yyyy-MM-dd').format(focusedStartDate.value),
      DateFormat('yyyy-MM-dd').format(focusedEndDate.value),
    );

    result.when(
      success: (result) {
        getListDate(result);
      },
      error: (message) {
        Get.snackbar('알림', '데이터를 불러오는데 실패했습니다.');
      },
    );
  }

  getListDate(List<EmotionStampData> result) async {
    _updateIsLoading(true);

    dataResult = {"key_ordered": [], "values": {}}.obs;

    addResultList = result.map((data) {
      var dateTime = weekOfMonthForSimple(DateTime.parse(data.createdAt!));
      if (!dataResult["key_ordered"].toString().contains(dateTime)) {
        (dataResult["key_ordered"] as List).add(dateTime);
        (dataResult["values"] as Map)[dateTime] = [];
      }

      (dataResult["values"] as Map)[dateTime].add(data);
    });

    print(addResultList);

    _updateIsLoading(false);
  }

  @override
  void onInit() {
    super.onInit();
    getEmotionStampList();
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
