import 'package:frontend/apis/on_boarding_api.dart';
import 'package:frontend/apis/response_result.dart';
import 'package:frontend/domain/model/my_information.dart';
import 'package:frontend/domain/repository/on_boarding_repository/on_boarding_repository.dart';

class OnBoardingRepositoryImpl implements OnBoardingRepository {
  final OnBoardingApi onBoardingApi;

  OnBoardingRepositoryImpl({
    required this.onBoardingApi,
  });

  @override
  Future<ResponseResult<MyInformation>> getMyInformation() async {
    if (myInformation != null) {
      if (myInformation!.nickname != null || myInformation!.age != null || myInformation!.email != null) {
        return ResponseResult.success(myInformation!);
      }
    }

    final result = await onBoardingApi.getMyInformation();
    result.when(
        success: (info) {
          myInformation = info.copyWith();
        },
        error: (message) {});

    return result;
  }

  @override
  Future<ResponseResult<bool>> putMyInformation({
    required nickname,
    required job,
    required age,
    required email,
  }) async {
    if (myInformation != null) {
      myInformation = myInformation!.copyWith(
        nickname: nickname,
        job: job,
        age: age,
        email: email,
      );
    }

    return await onBoardingApi.putMyInformation(
      nickname: nickname,
      job: job,
      age: age,
      email: email,
    );
  }

  @override
  void clearMyInformation() {
    myInformation = null;
  }
}

MyInformation? myInformation;
