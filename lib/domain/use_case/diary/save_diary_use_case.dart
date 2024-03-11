import 'package:frontend/core/result.dart';
import 'package:frontend/domain/model/diary/diary_detail_data.dart';
import 'package:frontend/domain/repository/diary/diary_repository.dart';

class SaveDiaryUseCase {
  final DiaryRepository diaryRepository;

  SaveDiaryUseCase({
    required this.diaryRepository,
  });

  Future<Result<DiaryDetailData>> call(DiaryDetailData diary) async {
    return await diaryRepository.saveDiary(diary);
  }
}
