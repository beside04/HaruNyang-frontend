import 'package:frontend/core/result.dart';
import 'package:frontend/domain/model/diary/diary_data.dart';
import 'package:frontend/domain/model/diary/diary_detail_data.dart';

abstract class DiaryRepository {
  Future<Result<DiaryDetailData>> getDiaryDetail(int id);

  Future<Result<DiaryDetailData>> saveDiary(DiaryData diary);

  Future<Result<DiaryDetailData>> updateDiary(DiaryData diary);

  Future<Result<bool>> deleteDiary(int diaryId);

  Future<Result<bool>> postImageHistory(String imageUrl);
}
