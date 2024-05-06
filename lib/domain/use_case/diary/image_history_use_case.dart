import 'package:frontend/apis/response_result.dart';
import 'package:frontend/domain/repository/diary/diary_repository.dart';

class ImageHistoryUseCase {
  final DiaryRepository diaryRepository;

  ImageHistoryUseCase({
    required this.diaryRepository,
  });

  Future<ResponseResult<bool>> call(String imageUrl) async {
    return await diaryRepository.postImageHistory(imageUrl);
  }
}
