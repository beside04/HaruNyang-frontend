import 'package:frontend/core/result.dart';
import 'package:frontend/data/data_source/remote_data/on_boarding_api.dart';
import 'package:frontend/domain/model/my_information.dart';
import 'package:frontend/domain/repository/on_boarding_repository/on_boarding_repository.dart';

class OnBoardingRepositoryImpl implements OnBoardingRepository {
  final OnBoardingApi onBoardingApi = OnBoardingApi();

  @override
  Future<Result<MyInformation>> getMyInformation() async {
    if (myInformation != null) {
      return Result.success(myInformation!);
    } else {
      final result = await onBoardingApi.getMyInformation();
      result.when(
          success: (info) {
            myInformation = info.copyWith();
          },
          error: (message) {});

      return result;
    }
  }

  @override
  Future<Result<MyInformation>> putMyInformation({
    required nickname,
    required job,
    required age,
  }) async {
    return await onBoardingApi.putMyInformation(
      nickname: nickname,
      job: job,
      age: age,
    );
  }
}

MyInformation? myInformation;
