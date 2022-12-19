import 'package:frontend/domain/model/diary/weather_data.dart';

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
