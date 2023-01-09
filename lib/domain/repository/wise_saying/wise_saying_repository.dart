import 'package:frontend/core/result.dart';
import 'package:frontend/domain/model/wise_saying/wise_saying_data.dart';

abstract class WiseSayingRepository {
  Future<Result<List<WiseSayingData>>> getWiseSaying(
      int emoticonId, String content);

  Future<Result<List<WiseSayingData>>> getRandomWiseSaying(int emoticonId);
}
