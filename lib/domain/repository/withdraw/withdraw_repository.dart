import 'package:frontend/core/result.dart';

abstract class WithdrawRepository {
  Future<Result<bool>> withdrawUser();
}
