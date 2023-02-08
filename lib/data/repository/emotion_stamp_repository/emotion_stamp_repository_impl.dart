import 'package:frontend/core/result.dart';
import 'package:frontend/data/data_source/remote_data/emotion_stamp_api.dart';
import 'package:frontend/domain/model/diary/diary_data.dart';
import 'package:frontend/domain/repository/emotion_stamp/emotion_stamp_repository.dart';

class EmotionStampRepositoryImpl implements EmotionStampRepository {
  final EmotionStampApi emotionStampApi;

  EmotionStampRepositoryImpl({
    required this.emotionStampApi,
  });

  @override
  Future<Result<List<DiaryData>>> getEmotionStamp(
      String from, String to) async {
    return await emotionStampApi.getEmotionStamp(from, to);
  }
}
