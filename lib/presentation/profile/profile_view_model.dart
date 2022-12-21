import 'package:frontend/domain/use_case/on_boarding_use_case/on_boarding_use_case.dart';
import 'package:get/get.dart';

class ProfileViewModel extends GetxController {
  final OnBoardingUseCase onBoardingUseCase;

  ProfileViewModel({
    required this.onBoardingUseCase,
  });

  final pushMessageValue = true.obs;
  final lightModeValue = true.obs;

  togglePushMessageValue() {
    pushMessageValue.value = !pushMessageValue.value;
  }

  toggleLightModeValue() {
    lightModeValue.value = !lightModeValue.value;
  }
}
