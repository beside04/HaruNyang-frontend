abstract class PopUpRepository {
  Future<String?> getLastPopUpDate();

  Future<String?> getLastBirthDayPopUpDate();

  Future<void> setLastPopUpDate(String lastPopUpDate);

  Future<void> setLastBirthDayPopUpDate(String lastPopUpDate);

  Future<void> deleteLastPopUpDate();
}
