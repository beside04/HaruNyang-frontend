import 'package:frontend/core/result.dart';
import 'package:frontend/domain/model/emotion_stamp/emotion_stamp_data.dart';

abstract class EmotionStampRepository {
  Future<Result<List<EmotionStampData>>> getEmotionStamp(
      String from, String to);
}
