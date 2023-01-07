abstract class DarkModeRepository {
  Future<String?> getIsDarkMode();

  Future<void> setDarkMode(String isDarkMode);

  Future<void> deleteDarkModeData();
}
