import 'package:frontend/apis/response_result.dart';
import 'package:frontend/domain/model/my_information.dart';
import 'package:frontend/domain/repository/on_boarding_repository/on_boarding_repository.dart';

class OnBoardingUseCase {
  final OnBoardingRepository onBoardingRepository;

  OnBoardingUseCase({
    required this.onBoardingRepository,
  });

  Future<ResponseResult<MyInformation>> getMyInformation() async {
    final result = await onBoardingRepository.getMyInformation();

    return result;
  }

  Future<ResponseResult<bool>> putMyInformation({
    required nickname,
    required job,
    required age,
    required email,
  }) async {
    final loginResult = await onBoardingRepository.putMyInformation(
      nickname: nickname,
      job: job,
      age: age,
      email: email,
    );

    return await loginResult.when(
      success: (successData) async {
        return ResponseResult.success(successData);
      },
      error: (message) {
        //로그인 에러 처리
        return ResponseResult.error(message);
      },
    );
  }
}
