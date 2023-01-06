import 'package:frontend/domain/repository/dark_mode/dark_mode_repository.dart';

class DarkModeUseCase {
  final DarkModeRepository darkModeRepository;

  DarkModeUseCase({
    required this.darkModeRepository,
  });

  Future<String?> getIsDarkMode() async {
    return await darkModeRepository.getIsDarkMode();
  }

  Future<void> setDarkMode(String isDarkMode) async {
    await darkModeRepository.setDarkMode(isDarkMode);
  }

  Future<void> deleteDarkModeData() async {
    await darkModeRepository.deleteDarkModeData();
  }
}
