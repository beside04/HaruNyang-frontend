import 'package:frontend/core/result.dart';
import 'package:frontend/domain/model/emotion_stamp/emotion_stamp_data.dart';
import 'package:frontend/domain/repository/emotion_stamp/emotion_stamp_repository.dart';

class GetEmotionStampUseCase {
  final EmotionStampRepository emotionStampRepository;

  GetEmotionStampUseCase({
    required this.emotionStampRepository,
  });

  Future<Result<List<EmotionStampData>>> call(String from, String to) async {
    return emotionStampRepository.getEmotionStamp(from, to);
  }
}
