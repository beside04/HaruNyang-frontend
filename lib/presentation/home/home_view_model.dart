import 'package:frontend/domain/use_case/on_boarding_use_case/apple_login_use_case.dart';
import 'package:get/get.dart';

class HomeViewModel extends GetxController {
  final OnBoardingUseCase onBoardingUseCase;

  HomeViewModel({
    required this.onBoardingUseCase,
  });

  Future<void> getMyInformation() async {
    await onBoardingUseCase.getMyInformation();
  }
}
