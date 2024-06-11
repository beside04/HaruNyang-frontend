import 'package:frontend/data/data_source/local_data/shared_preferences/password_data_source.dart';
import 'package:frontend/domain/repository/password/password_repository.dart';

class PasswordRepositoryImpl implements PasswordRepository {
  final PasswordDataSource _dataSource = PasswordDataSource();

  @override
  Future<bool?> getIsPasswordSetting() async {
    return await _dataSource.getIsPassword();
  }

  @override
  Future<void> setIsPassword(bool data) async {
    return await _dataSource.setIsPassword(data);
  }

  @override
  Future<String?> getPassword() async {
    return await _dataSource.getPassword();
  }

  @override
  Future<void> setPassword(String data) async {
    return await _dataSource.setPassword(data);
  }

  @override
  Future<bool?> getIsBioAuth() async {
    return await _dataSource.getIsBioAuth();
  }

  @override
  Future<void> setIsBioAuth(bool data) async {
    return await _dataSource.setIsBioAuth(data);
  }

  @override
  Future<String?> getHint() async {
    return await _dataSource.getHint();
  }

  @override
  Future<void> setHint(String data) async {
    return await _dataSource.setHint(data);
  }

  @override
  Future<void> deleteHint() async {
    return await _dataSource.deleteHint();
  }
}
