import 'package:frontend/domain/use_case/on_boarding_use_case/on_boarding_use_case.dart';
import 'package:frontend/res/constants.dart';
import 'package:get/get.dart';

class OnBoardingJobViewModel extends GetxController {
  final Rx<Job?> jobStatus = Rx<Job?>(null);
}
