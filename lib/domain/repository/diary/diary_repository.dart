import 'package:frontend/apis/response_result.dart';
import 'package:frontend/domain/model/diary/diary_detail_data.dart';

abstract class DiaryRepository {
  Future<ResponseResult<DiaryDetailData>> getDiaryDetail(int id);

  Future<ResponseResult<DiaryDetailData>> saveDiary(DiaryDetailData diary);

  Future<ResponseResult<DiaryDetailData>> updateDiary(DiaryDetailData diary);

  Future<ResponseResult<bool>> deleteDiary(int diaryId);

  Future<ResponseResult<bool>> postImageHistory(String imageUrl);
}
