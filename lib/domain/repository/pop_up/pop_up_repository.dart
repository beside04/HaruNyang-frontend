abstract class PopUpRepository {
  Future<String?> getLastPopUpDate();

  Future<void> setLastPopUpDate(String lastPopUpDate);

  Future<void> deleteLastPopUpDate();
}
