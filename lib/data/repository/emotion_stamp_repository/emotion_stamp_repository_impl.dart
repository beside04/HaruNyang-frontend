import 'package:frontend/core/result.dart';
import 'package:frontend/data/data_source/remote_data/emotion_stamp_api.dart';
import 'package:frontend/domain/model/emotion_stamp/emotion_stamp_data.dart';
import 'package:frontend/domain/repository/emotion_stamp/emotion_stamp_repository.dart';

class EmotionStampRepositoryImpl implements EmotionStampRepository {
  final EmotionStampApi emotionDiaryApi = EmotionStampApi();

  @override
  Future<Result<List<EmotionStampData>>> getEmotionStamp(
      String from, String to) async {
    return await emotionDiaryApi.getEmotionStamp(from, to);
  }
}
