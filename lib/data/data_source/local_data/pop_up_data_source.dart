import 'package:frontend/data/data_source/local_data/local_secure_data_source.dart';

class PopUpDataSource {
  final LocalSecureDataSource localSecureDataSource = LocalSecureDataSource();

  Future<String?> getLastPopUpDate() async {
    return await localSecureDataSource.loadData(
      key: 'LAST_POP_UP_DATE',
    );
  }

  Future<void> setLastPopUpDate(data) async {
    return await localSecureDataSource.saveData(
      key: 'LAST_POP_UP_DATE',
      data: data,
    );
  }

  Future<void> deleteLastPopUpDate() async {
    return await localSecureDataSource.deleteData(
      key: 'LAST_POP_UP_DATE',
    );
  }
}
