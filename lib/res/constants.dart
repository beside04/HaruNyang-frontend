import 'package:frontend/domain/model/diary/emotion_data.dart';
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

List<EmotionData> emotionDataList = [
  EmotionData(
    name: "기뻐",
    icon: 'lib/config/assets/images/diary/emotion/happy.svg',
    value: 'happy',
    writeValue: "오늘 가장 기쁜 일은\n무엇이었나요?",
  ),
  EmotionData(
    name: "슬퍼",
    icon: 'lib/config/assets/images/diary/emotion/sad.svg',
    value: 'sad',
    writeValue: "오늘 가장 슬픈 일은\n무엇이었나요?",
  ),
  EmotionData(
    name: "화나",
    icon: 'lib/config/assets/images/diary/emotion/angry.svg',
    value: 'angry',
    writeValue: "오늘 가장 화나는 일은\n무엇이었나요?",
  ),
  EmotionData(
    name: "신나",
    icon: 'lib/config/assets/images/diary/emotion/enjoy.svg',
    value: 'enjoy',
    writeValue: "오늘 가장 신나는 일은\n무엇이었나요?",
  ),
  EmotionData(
    name: "힘들어",
    icon: 'lib/config/assets/images/diary/emotion/tired.svg',
    value: 'tired',
    writeValue: "오늘 가장 힘든 일은\n무엇이었나요?",
  ),
  EmotionData(
    name: "놀라워",
    icon: 'lib/config/assets/images/diary/emotion/suprise2.svg',
    value: 'tired',
    writeValue: "오늘 가장 놀란 일은\n무엇이었나요?",
  ),
  EmotionData(
    name: "그저그래",
    icon: 'lib/config/assets/images/diary/emotion/soso.svg',
    value: 'soso',
    writeValue: "오늘 그저그런 일은\n무엇이었나요?",
  ),
  EmotionData(
    name: "당황스러워",
    icon: 'lib/config/assets/images/diary/emotion/embarrassment.svg',
    value: 'embarrassment',
    writeValue: "오늘 가장 당황스러운 일은\n무엇이었나요?",
  ),
  EmotionData(
    name: "설레",
    icon: 'lib/config/assets/images/diary/emotion/good.svg',
    value: 'good',
    writeValue: "오늘 가장 설레는 일은\n무엇이었나요?",
  ),
];
