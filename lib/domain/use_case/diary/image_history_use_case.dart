import 'package:frontend/core/result.dart';
import 'package:frontend/domain/repository/diary/diary_repository.dart';

class ImageHistoryUseCase {
  final DiaryRepository diaryRepository;

  ImageHistoryUseCase({
    required this.diaryRepository,
  });

  Future<Result<bool>> call(String imageUrl) async {
    return await diaryRepository.postImageHistory(imageUrl);
  }
}
