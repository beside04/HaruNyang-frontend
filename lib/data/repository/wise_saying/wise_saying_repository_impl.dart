import 'package:frontend/core/result.dart';
import 'package:frontend/data/data_source/remote_data/wise_saying_api.dart';
import 'package:frontend/domain/model/wise_saying/wise_saying_data.dart';
import 'package:frontend/domain/repository/wise_saying/wise_saying_repository.dart';

class WiseSayingRepositoryImpl implements WiseSayingRepository {
  final WiseSayingApi wiseSayingApi;

  WiseSayingRepositoryImpl({
    required this.wiseSayingApi,
  });

  @override
  Future<Result<List<WiseSayingData>>> getWiseSaying(
      int emoticonId, String content) async {
    return await wiseSayingApi.getWiseSaying(emoticonId, content);
  }

  @override
  Future<Result<List<WiseSayingData>>> getRandomWiseSaying(
      int emoticonId) async {
    return await wiseSayingApi.getRandomWiseSaying(emoticonId);
  }
}
