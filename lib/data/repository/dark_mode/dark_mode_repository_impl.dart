import 'package:frontend/data/data_source/local_data/secure_storage/dark_mode_data_source.dart';
import 'package:frontend/domain/repository/dark_mode/dark_mode_repository.dart';

class DarkModeRepositoryImpl implements DarkModeRepository {
  final DarkModeDataSource _dataSource = DarkModeDataSource();

  @override
  Future<String?> getIsDarkMode() async {
    return await _dataSource.getIsDarkMode();
  }

  @override
  Future<void> setDarkMode(String isDarkMode) async {
    await _dataSource.setDarkMode(isDarkMode);
  }

  @override
  Future<void> deleteDarkModeData() async {
    await _dataSource.deleteDarkModeData();
  }
}
