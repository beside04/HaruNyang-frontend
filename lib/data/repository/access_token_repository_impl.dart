import 'package:frontend/data/data_source/local_data/memory_access_token_data_source.dart';
import 'package:frontend/domain/repository/aceess_token_repository.dart';

class AccessTokenRepositoryImpl implements AccessTokenRepository {
  final MemoryAccessTokenDataSource _dataSource = MemoryAccessTokenDataSource();

  @override
  Future<String> getAccessToken() async {
    return _dataSource.getAccessToken();
  }

  @override
  Future<void> setAccessToken(String token) async {
    _dataSource.setAccessToken(token);
  }
}
