import 'package:frontend/core/result.dart';
import 'package:frontend/domain/model/wise_saying/wise_saying_data.dart';
import 'package:frontend/domain/repository/wise_saying/wise_saying_repository.dart';

class GetWiseSayingUseCase {
  final WiseSayingRepository wiseSayingRepository;

  GetWiseSayingUseCase({
    required this.wiseSayingRepository,
  });

  Future<Result<List<WiseSayingData>>> call(
      int emoticonId, String content) async {
    return wiseSayingRepository.getWiseSaying(emoticonId, content);
  }
}
