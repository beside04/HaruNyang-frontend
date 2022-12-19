import 'package:frontend/core/result.dart';
import 'package:frontend/data/data_source/remote_data/withdraw_api.dart';
import 'package:frontend/domain/repository/withdraw/withdraw_repository.dart';

class WithdrawRepositoryImpl implements WithdrawRepository {
  final WithdrawApi _dataSource = WithdrawApi();

  @override
  Future<Result<bool>> withdrawUser() async {
    return await _dataSource.withdrawUser();
  }
}
