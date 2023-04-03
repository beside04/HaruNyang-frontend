import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/domain/model/on_boarding/job_data.dart';

// ignore: constant_identifier_names
const int APP_BUILD_NUMBER = 3;
// ignore: constant_identifier_names
const String APP_VERSION_NUMBER = '1.0.7';

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

Widget getEmotionTextWidget(int value, TextStyle style) {
  if (value < 1.0) {
    return Text("조금", style: style);
  } else if (value < 2.0) {
    return Text("그럭저럭", style: style);
  } else if (value < 3.0) {
    return Text("맞아!", style: style);
  } else {
    return Text("진짜 엄청 대박!!", style: style);
  }
}
