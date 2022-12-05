import 'package:frontend/core/result.dart';
import 'package:frontend/domain/model/my_information.dart';
import 'package:frontend/domain/use_case/on_boarding_use_case/on_boarding_use_case.dart';
import 'package:get/get.dart';

class ProfileViewModel extends GetxController {
  final OnBoardingUseCase onBoardingUseCase;

  ProfileViewModel({
    required this.onBoardingUseCase,
  });

  String? nickname = '';
  String? job = '';
  String? age = '';
  String? loginType = '';
  String? email = '';

  Future<Result<MyInformation>> getMyInformation() async {
    final getMyInformation = await onBoardingUseCase.getMyInformation();

    return getMyInformation.when(
      success: (successData) async {
        nickname = successData.nickname;
        job = successData.job;
        age = successData.age;
        loginType = successData.loginType;
        email = successData.email;
        update();
        return Result.success(successData);
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }
}
