import 'package:frontend/apis/response_result.dart';
import 'package:frontend/apis/withdraw_api.dart';
import 'package:frontend/domain/repository/withdraw/withdraw_repository.dart';

class WithdrawRepositoryImpl implements WithdrawRepository {
  final WithdrawApi withdrawApi;

  WithdrawRepositoryImpl({
    required this.withdrawApi,
  });

  @override
  Future<ResponseResult<bool>> withdrawUser() async {
    return await withdrawApi.withdrawUser();
  }
}
