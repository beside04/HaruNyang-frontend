import 'package:flutter/foundation.dart';
import 'package:frontend/domain/model/on_boarding/job_data.dart';

// ignore: constant_identifier_names
const int APP_BUILD_NUMBER = 8;
// ignore: constant_identifier_names
const String APP_VERSION_NUMBER = '2.0.3';

// ignore: constant_identifier_names
const Map<String, String> UNIT_ID = kReleaseMode
    ? {
        'ios': 'ca-app-pub-8586165570578765/8453529848',
        'android': 'ca-app-pub-8586165570578765/5103396054',
      }
    : {
        'ios': 'ca-app-pub-3940256099942544/2934735716',
        'android': 'ca-app-pub-3940256099942544/6300978111',
      };

enum Job {
  student,
  officeWorkers,
  jobSeeker,
  freelancer,
  rest,
  etc,
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

List<JobData> jobList = [
  JobData(
    name: "학생",
    icon: 'lib/config/assets/images/on_boarding/student.svg',
    value: 'student',
  ),
  JobData(
    name: "직장인",
    icon: 'lib/config/assets/images/on_boarding/office_workers.svg',
    value: 'officeWorkers',
  ),
  JobData(
    name: "취준생",
    icon: 'lib/config/assets/images/on_boarding/job_seeker.svg',
    value: 'jobSeeker',
  ),
  JobData(
    name: "프리랜서",
    icon: 'lib/config/assets/images/on_boarding/freelancer.svg',
    value: 'freelancer',
  ),
  JobData(
    name: "휴식중",
    icon: 'lib/config/assets/images/on_boarding/rest.svg',
    value: 'rest',
  ),
  JobData(
    name: "기타",
    icon: 'lib/config/assets/images/on_boarding/etc.svg',
    value: 'etc',
  ),
];

String getEmoticonImage(String value) {
  switch (value) {
    case 'HAPPINESS':
      return 'lib/config/assets/images/character/happy.png';
    case 'SADNESS':
      return 'lib/config/assets/images/character/sad2.png';
    case 'ANGRY':
      return 'lib/config/assets/images/character/angry.png';
    case 'EXCITED':
      return 'lib/config/assets/images/character/excited.png';
    case 'TIRED':
      return 'lib/config/assets/images/character/tired.png';
    case 'SURPRISED':
      return 'lib/config/assets/images/character/amazed.png';
    case 'NEUTRAL':
      return 'lib/config/assets/images/character/soso.png';
    case 'FLUTTER':
      return 'lib/config/assets/images/character/blushed.png';
    case 'UNCERTAIN':
      return 'lib/config/assets/images/character/molra.png';
    default:
      return '';
  }
}

String getEmoticonValue(String value) {
  switch (value) {
    case 'HAPPINESS':
      return '기뻐';
    case 'SADNESS':
      return '슬퍼';
    case 'ANGRY':
      return '화나';
    case 'EXCITED':
      return '신나';
    case 'TIRED':
      return '힘들어';
    case 'SURPRISED':
      return '놀랐어';
    case 'NEUTRAL':
      return '그저그래';
    case 'FLUTTER':
      return '설레';
    case 'UNCERTAIN':
      return '몰라';
    default:
      return '';
  }
}

String getWeatherImage(String value) {
  switch (value) {
    case 'SUNNY':
      return 'lib/config/assets/images/diary/weather/sunny.png';
    case 'CLOUDY':
      return 'lib/config/assets/images/diary/weather/cloudy.png';
    case 'RAINY':
      return 'lib/config/assets/images/diary/weather/rainy.png';
    case 'SNOWY':
      return 'lib/config/assets/images/diary/weather/snowy.png';
    case 'WINDY':
      return 'lib/config/assets/images/diary/weather/windy.png';
    case 'THUNDER':
      return 'lib/config/assets/images/diary/weather/thunder.png';
    default:
      return '';
  }
}

String getWeatherValue(String value) {
  switch (value) {
    case 'SUNNY':
      return '맑음';
    case 'CLOUDY':
      return '흐림';
    case 'RAINY':
      return '비';
    case 'SNOWY':
      return '눈';
    case 'WINDY':
      return '바람';
    case 'THUNDER':
      return '번개';
    default:
      return '';
  }
}

String getWeatherCharacter(String value) {
  switch (value) {
    case 'SUNNY':
      return 'lib/config/assets/images/character/sunny.png';
    case 'CLOUDY':
      return 'lib/config/assets/images/character/cloudy.png';
    case 'RAINY':
      return 'lib/config/assets/images/character/rainy.png';
    case 'SNOWY':
      return 'lib/config/assets/images/character/snowy.png';
    case 'WINDY':
      return 'lib/config/assets/images/character/windy.png';
    case 'THUNDER':
      return 'lib/config/assets/images/character/thunder.png';
    default:
      return '';
  }
}

String getWeatherAnimation(String value) {
  switch (value) {
    case 'SUNNY':
      return '';
    case 'CLOUDY':
      return '';
    case 'RAINY':
      return 'lib/config/assets/images/character/rain.riv';
    case 'SNOWY':
      return '';
    case 'WINDY':
      return '';
    case 'THUNDER':
      return '';
    default:
      return '';
  }
}
