import 'package:frontend/core/result.dart';
import 'package:frontend/data/data_source/remote_data/diary_api.dart';
import 'package:frontend/domain/model/diary/diary_data.dart';
import 'package:frontend/domain/repository/diary/diary_repository.dart';

class DiaryRepositoryImpl implements DiaryRepository {
  final DiaryApi diaryApi;

  DiaryRepositoryImpl({
    required this.diaryApi,
  });

  @override
  Future<Result<String>> saveDiary(DiaryData diary) async {
    return await diaryApi.saveDiary(diary);
  }

  @override
  Future<Result<bool>> updateDiary(DiaryData diary) async {
    return await diaryApi.updateDiary(diary);
  }

  @override
  Future<Result<bool>> deleteDiary(String diaryId) async {
    return await diaryApi.deleteDiary(diaryId);
  }
}
