import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/res/constants.dart';
import 'package:get/get.dart';

// class OnBoardingJobViewModel extends GetxController {
//   final Rx<Job?> jobStatus = Rx<Job?>(null);
// }

final onBoardingJobProvider = StateNotifierProvider<OnBoardingJobNotifier, Job?>((ref) => OnBoardingJobNotifier());

class OnBoardingJobNotifier extends StateNotifier<Job?> {
  OnBoardingJobNotifier() : super(null);
}
