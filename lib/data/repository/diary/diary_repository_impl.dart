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

  @override
  Future<Result<bool>> updateDiary(DiaryData diary) async {
    return await _dataSource.updateDiary(diary);
  }

  @override
  Future<Result<bool>> deleteDiary(String diaryId) async {
    return await _dataSource.deleteDiary(diaryId);
  }
}
