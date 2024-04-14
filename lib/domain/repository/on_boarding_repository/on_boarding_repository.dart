import 'package:frontend/apis/response_result.dart';
import 'package:frontend/domain/model/my_information.dart';

abstract class OnBoardingRepository {
  Future<ResponseResult<MyInformation>> getMyInformation();

  Future<ResponseResult<bool>> putMyInformation({
    required nickname,
    required job,
    required age,
    required email,
  });

  void clearMyInformation();
}
