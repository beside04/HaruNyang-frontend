import 'package:frontend/data/data_source/local_data/memory_token_data_source.dart';
import 'package:frontend/domain/repository/token_repository.dart';

class TokenRepositoryImpl implements TokenRepository {
  final MemoryTokenDataSource _dataSource = MemoryTokenDataSource();

  @override
  Future<String?> getAccessToken() async {
    return await _dataSource.getAccessToken();
  }

  @override
  Future<void> setAccessToken(String token) async {
    await _dataSource.setAccessToken(token);
  }

  @override
  Future<String?> getRefreshToken() async {
    return await _dataSource.getRefreshToken();
  }

  @override
  Future<void> setRefreshToken(String token) async {
    await _dataSource.setRefreshToken(token);
  }

  @override
  Future<void> deleteAllToken() async {
    await _dataSource.deleteAllToken();
  }
}
