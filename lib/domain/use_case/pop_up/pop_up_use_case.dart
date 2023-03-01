import 'package:frontend/domain/repository/pop_up/pop_up_repository.dart';

class PopUpUseCase {
  final PopUpRepository popUpRepository;

  PopUpUseCase({
    required this.popUpRepository,
  });

  Future<String?> getLastPopUpDate() async {
    return await popUpRepository.getLastPopUpDate();
  }

  Future<void> setLastPopUpDate(String lastPopUpDate) async {
    await popUpRepository.setLastPopUpDate(lastPopUpDate);
  }

  Future<void> deleteLastPopUpDate() async {
    await popUpRepository.deleteLastPopUpDate();
  }
}
