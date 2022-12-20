import 'package:frontend/core/result.dart';
import 'package:frontend/domain/model/diary/diary_data.dart';

abstract class DiaryRepository {
  Future<Result<bool>> saveDiary(DiaryData diary);

  Future<Result<bool>> updateDiary(DiaryData diary);

  Future<Result<bool>> deleteDiary(String diaryId);
}
