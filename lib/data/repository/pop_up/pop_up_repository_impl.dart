import 'package:frontend/data/data_source/local_data/pop_up_data_source.dart';
import 'package:frontend/domain/repository/pop_up/pop_up_repository.dart';

class PopUpRepositoryImpl implements PopUpRepository {
  final PopUpDataSource _dataSource = PopUpDataSource();

  @override
  Future<String?> getLastPopUpDate() async {
    return await _dataSource.getLastPopUpDate();
  }

  @override
  Future<void> setLastPopUpDate(String lastPopUpDate) async {
    await _dataSource.setLastPopUpDate(lastPopUpDate);
  }

  @override
  Future<void> deleteLastPopUpDate() async {
    await _dataSource.deleteLastPopUpDate();
  }
}
