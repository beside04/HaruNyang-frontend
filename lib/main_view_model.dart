import 'package:frontend/domain/use_case/on_boarding_use_case/apple_login_use_case.dart';
import 'package:frontend/domain/use_case/token_use_case.dart';
import 'package:get/get.dart';

class MainViewModel extends GetxController {
  final TokenUseCase tokenUseCase;
  final OnBoardingUseCase onBoardingUseCase;

  MainViewModel({
    required this.tokenUseCase,
    required this.onBoardingUseCase,
  });

  String? token;
  RxBool isValidated = false.obs;

  Future<void> getMyInformation() async {
    final getMyInformation = await onBoardingUseCase.getMyInformation();

    getMyInformation.when(
      success: (successData) async {
        isValidated.value = true;
      },
      error: (message) {},
    );
  }

  Future<void> getAccessToken() async {
    token = await tokenUseCase.getAccessToken();
  }
}
