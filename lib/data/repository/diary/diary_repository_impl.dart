import 'package:frontend/apis/diary_api.dart';
import 'package:frontend/apis/response_result.dart';
import 'package:frontend/domain/model/diary/diary_detail_data.dart';
import 'package:frontend/domain/repository/diary/diary_repository.dart';

class DiaryRepositoryImpl implements DiaryRepository {
  final DiaryApi diaryApi;

  DiaryRepositoryImpl({
    required this.diaryApi,
  });

  @override
  Future<ResponseResult<DiaryDetailData>> getDiaryDetail(int id) async {
    return await diaryApi.getDiaryDetail(id);
  }

  @override
  Future<ResponseResult<DiaryDetailData>> saveDiary(DiaryDetailData diary) async {
    return await diaryApi.saveDiary(diary);
  }

  @override
  Future<ResponseResult<DiaryDetailData>> updateDiary(DiaryDetailData diary) async {
    return await diaryApi.updateDiary(diary);
  }

  @override
  Future<ResponseResult<bool>> deleteDiary(int diaryId) async {
    return await diaryApi.deleteDiary(diaryId);
  }

  @override
  Future<ResponseResult<bool>> postImageHistory(String imageUrl) async {
    return await diaryApi.postImageHistory(imageUrl);
  }
}
