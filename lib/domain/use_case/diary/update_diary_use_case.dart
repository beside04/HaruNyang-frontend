import 'package:frontend/core/result.dart';
import 'package:frontend/domain/model/diary/diary_detail_data.dart';
import 'package:frontend/domain/repository/diary/diary_repository.dart';

class UpdateDiaryUseCase {
  final DiaryRepository diaryRepository;

  UpdateDiaryUseCase({
    required this.diaryRepository,
  });

  Future<Result<DiaryDetailData>> call(DiaryDetailData diary) async {
    return await diaryRepository.updateDiary(diary);
  }
}
