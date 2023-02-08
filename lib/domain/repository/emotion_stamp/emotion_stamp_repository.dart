import 'package:frontend/core/result.dart';

import 'package:frontend/domain/model/diary/diary_data.dart';

abstract class EmotionStampRepository {
  Future<Result<List<DiaryData>>> getEmotionStamp(String from, String to);
}
