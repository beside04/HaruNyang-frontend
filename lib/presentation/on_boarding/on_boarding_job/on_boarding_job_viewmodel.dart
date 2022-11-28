import 'package:frontend/domain/model/on_boarding/job_data.dart';
import 'package:frontend/domain/use_case/on_boarding_use_case/apple_login_use_case.dart';
import 'package:frontend/res/constants.dart';
import 'package:get/get.dart';

class OnBoardingJobViewModel extends GetxController {
  final OnBoardingUseCase onBoardingUseCase;

  OnBoardingJobViewModel({
    required this.onBoardingUseCase,
  });

  Future<void> putMyInformation({
    required nickname,
    required job,
    required age,
  }) async {
    onBoardingUseCase.putMyInformation(nickname: nickname, job: job, age: age);
  }

  final Rx<Job> jobStatus = Job.student.obs;
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
  ].obs;
}
