import 'package:frontend/core/result.dart';
import 'package:frontend/data/data_source/remote_data/withdraw_api.dart';
import 'package:frontend/domain/repository/withdraw/withdraw_repository.dart';

class WithdrawRepositoryImpl implements WithdrawRepository {
  final WithdrawApi withdrawApi;

  WithdrawRepositoryImpl({
    required this.withdrawApi,
  });

  @override
  Future<Result<bool>> withdrawUser() async {
    return await withdrawApi.withdrawUser();
  }
}
