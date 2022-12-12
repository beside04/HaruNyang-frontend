import 'package:frontend/data/data_source/remote_data/withdraw_api.dart';
import 'package:frontend/domain/repository/withdraw_repository.dart';

class WithdrawRepositoryImpl implements WithdrawRepository {
  final WithdrawApi _dataSource = WithdrawApi();

  @override
  Future<void> withdrawUser() async {
    return await _dataSource.withdrawal();
  }
}
