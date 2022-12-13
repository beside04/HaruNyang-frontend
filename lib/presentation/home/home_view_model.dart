import 'package:frontend/domain/use_case/on_boarding_use_case/on_boarding_use_case.dart';
import 'package:get/get.dart';

class HomeViewModel extends GetxController {
  final OnBoardingUseCase onBoardingUseCase;

  HomeViewModel({
    required this.onBoardingUseCase,
  }) {
    fetchData();
  }

  Future<void> fetchData() async {
    //토큰 확인
    await getMyInformation();
  }

  Future<void> getMyInformation() async {
    await onBoardingUseCase.getMyInformation();
  }
}
