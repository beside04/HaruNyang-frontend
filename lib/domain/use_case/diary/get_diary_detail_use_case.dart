import 'package:frontend/apis/response_result.dart';
import 'package:frontend/domain/model/diary/diary_detail_data.dart';
import 'package:frontend/domain/repository/diary/diary_repository.dart';

class GetDiaryDetailUseCase {
  final DiaryRepository diaryRepository;

  GetDiaryDetailUseCase({
    required this.diaryRepository,
  });

  Future<ResponseResult<DiaryDetailData>> call(int id) async {
    return await diaryRepository.getDiaryDetail(id);
  }
}
