import 'package:dio/dio.dart';
import 'package:frontend/apis/dio.dart';
import 'package:frontend/core/result.dart';
import 'package:frontend/domain/model/diary/diary_data.dart';
import 'package:frontend/domain/model/diary/diary_detail_data.dart';
import 'package:retrofit/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'diary_repository.g.dart';

var apiEndPoint = '';

final diaryRepositoryProvider = Provider<DiaryRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return DiaryRepository(dio, baseUrl: apiEndPoint);
});

@RestApi()
abstract class DiaryRepository {
  factory DiaryRepository(Dio dio, {String baseUrl}) = _DiaryRepository;

  @GET('_baseUrl/v2/diaries/{id}')
  Future<Result<DiaryDetailData>> getDiaryDetail(
    @Query('id') int id,
  );

  //TODO _baseUrl 업데이트 해야합니다.
  @POST('_baseUrl/v2/diaries')
  Future<Result<DiaryDetailData>> saveDiary(
    @Body() DiaryData diary,
  );

  @POST('_baseUrl/v2/diaries/{diaryId}')
  Future<Result<DiaryDetailData>> updateDiary(
    @Body() DiaryData diary,
    @Path('diaryId') String diaryId,
  );

  @DELETE('_baseUrl/v2/diaries/{diaryId}')
  Future<Result<bool>> deleteDiary(
    @Path('diaryId') int diaryId,
  );
}
