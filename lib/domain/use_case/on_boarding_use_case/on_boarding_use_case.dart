import 'package:frontend/core/result.dart';
import 'package:frontend/domain/model/my_information.dart';
import 'package:frontend/domain/repository/on_boarding_repository/on_boarding_repository.dart';

class OnBoardingUseCase {
  final OnBoardingRepository onBoardingRepository;

  OnBoardingUseCase({
    required this.onBoardingRepository,
  });

  Future<Result<MyInformation>> getMyInformation() async {
    final result = await onBoardingRepository.getMyInformation();

    return result;
  }

  Future<Result<MyInformation>> putMyInformation({
    required nickname,
    required job,
    required age,
  }) async {
    final loginResult = await onBoardingRepository.putMyInformation(
      nickname: nickname,
      job: job,
      age: age,
    );

    return await loginResult.when(
      success: (successData) async {
        return Result.success(successData);
      },
      error: (message) {
        //로그인 에러 처리
        return Result.error(message);
      },
    );
  }
}
