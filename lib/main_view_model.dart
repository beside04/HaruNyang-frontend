import 'package:frontend/core/result.dart';
import 'package:frontend/domain/model/my_information.dart';
import 'package:frontend/domain/use_case/on_boarding_use_case/on_boarding_use_case.dart';
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
  String? job;
  String? age;
  String? nickname;
  String? loginType;
  String? email;

  Future<void> getAccessToken() async {
    token = await tokenUseCase.getAccessToken();
  }

  Future<Result<MyInformation>> getMyInformation() async {
    final getMyInformation = await onBoardingUseCase.getMyInformation();

    return getMyInformation.when(
      success: (successData) async {
        job = successData.job;
        age = successData.age;
        nickname = successData.nickname;
        loginType = successData.loginType;
        email = successData.email;
        return Result.success(successData);
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }
}
