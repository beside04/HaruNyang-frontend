import 'package:frontend/apis/response_result.dart';

abstract class WithdrawRepository {
  Future<ResponseResult<bool>> withdrawUser();
}
