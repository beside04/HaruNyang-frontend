import 'package:frontend/core/result.dart';
import 'package:frontend/data/data_source/remote_data/diary_api.dart';
import 'package:frontend/domain/model/diary/diary_data.dart';
import 'package:frontend/domain/repository/diary/diary_repository.dart';

class DiaryRepositoryImpl implements DiaryRepository {
  final DiaryApi _dataSource = DiaryApi();

  @override
  Future<Result<bool>> saveDiary(DiaryData diary) async {
    return await _dataSource.saveDiary(diary);
  }
}
