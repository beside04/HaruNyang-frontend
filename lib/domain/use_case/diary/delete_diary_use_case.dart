import 'package:frontend/apis/response_result.dart';
import 'package:frontend/domain/repository/diary/diary_repository.dart';

class DeleteDiaryUseCase {
  final DiaryRepository diaryRepository;

  DeleteDiaryUseCase({
    required this.diaryRepository,
  });

  Future<ResponseResult<bool>> call(int diaryId) async {
    return await diaryRepository.deleteDiary(diaryId);
  }
}
