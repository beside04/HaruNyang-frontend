import 'package:flutter/widgets.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/domain/model/diary/weather_data.dart';
import 'package:frontend/domain/model/on_boarding/job_data.dart';

enum Job {
  student,
  officeWorkers,
  jobSeeker,
  freelancer,
  rest,
  etc,
}

enum Weather {
  sunny,
  cloudy,
  rainy,
  snow,
  windy,
  thunder,
}

enum Emotion {
  happy,
  sad,
  angry,
  enjoy,
  tired,
  suprise,
  soso,
  embarrassment,
  good,
}

const String refreshTokenKey = '4team_refresh_token';

enum SocialIDCheck {
  existMember,
  notMember,
  error,
}

const int getEmoticonLimitCount = 100;

List<WeatherData> weatherDataList = [
  WeatherData(
    name: "맑음",
    icon: 'lib/config/assets/images/diary/weather/sunny.svg',
    value: 'sunny',
  ),
  WeatherData(
    name: "흐림",
    icon: 'lib/config/assets/images/diary/weather/cloudy.svg',
    value: 'cloudy',
  ),
  WeatherData(
    name: "비",
    icon: 'lib/config/assets/images/diary/weather/rainy.svg',
    value: 'rainy',
  ),
  WeatherData(
    name: "눈",
    icon: 'lib/config/assets/images/diary/weather/snow.svg',
    value: 'snow',
  ),
  WeatherData(
    name: "바람",
    icon: 'lib/config/assets/images/diary/weather/windy.svg',
    value: 'windy',
  ),
  WeatherData(
    name: "번개",
    icon: 'lib/config/assets/images/diary/weather/thunder.svg',
    value: 'thunder',
  ),
];

List<JobData> jobList = [
  JobData(
    name: "학생",
    icon: '🧑‍🎓',
    value: 'student',
  ),
  JobData(
    name: "직장인",
    icon: '🧑‍💼',
    value: 'officeWorkers',
  ),
  JobData(
    name: "취준생",
    icon: '🧑‍💻',
    value: 'jobSeeker',
  ),
  JobData(
    name: "프리랜서",
    icon: '🧙',
    value: 'freelancer',
  ),
  JobData(
    name: "휴식중",
    icon: '🏝',
    value: 'rest',
  ),
  JobData(
    name: "기타",
    icon: '🎸',
    value: 'etc',
  ),
];

Widget getEmotionTextWidget(value) {
  if (value < 20.0) {
    return Text("전혀", style: kBody1BlackStyle);
  } else if (value < 40.0) {
    return Text("조금?", style: kBody1BlackStyle);
  } else if (value < 60.0) {
    return Text("그럭저럭", style: kBody1BlackStyle);
  } else if (value < 80.0) {
    return Text("맞아!", style: kBody1BlackStyle);
  } else {
    return Text("진짜 엄청 대박!!", style: kBody1BlackStyle);
  }
}
