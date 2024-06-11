import 'package:frontend/data/data_source/local_data/secure_storage/memory_token_data_source.dart';
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
  Future<String?> getDeviceId() async {
    return await _dataSource.getDeviceId();
  }

  @override
  Future<void> setDeviceId(String id) async {
    await _dataSource.setDeviceId(id);
  }

  @override
  Future<String?> getLoginType() async {
    return await _dataSource.getLoginType();
  }

  @override
  Future<void> setLoginType(String type) async {
    await _dataSource.setLoginType(type);
  }

  @override
  Future<String?> getSocialId() async {
    return await _dataSource.getSocialId();
  }

  @override
  Future<void> setSocialId(String id) async {
    await _dataSource.setSocialId(id);
  }

  @override
  Future<void> deleteAllToken() async {
    await _dataSource.deleteAllToken();
  }
}
