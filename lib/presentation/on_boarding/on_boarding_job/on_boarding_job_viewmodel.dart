import 'package:frontend/domain/model/on_boarding/job_data.dart';
import 'package:frontend/domain/use_case/on_boarding_use_case/on_boarding_use_case.dart';
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

  final Rx<Job?> jobStatus = Rx<Job?>(null);
}
