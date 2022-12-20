import 'package:frontend/core/result.dart';
import 'package:frontend/domain/repository/diary/diary_repository.dart';

class DeleteDiaryUseCase {
  final DiaryRepository diaryRepository;

  DeleteDiaryUseCase({
    required this.diaryRepository,
  });

  Future<Result<bool>> call(String diaryId) async {
    return await diaryRepository.deleteDiary(diaryId);
  }
}
