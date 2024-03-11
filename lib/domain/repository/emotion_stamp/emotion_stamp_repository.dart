import 'package:frontend/core/result.dart';
import 'package:frontend/domain/model/diary/diary_detail_data.dart';

abstract class EmotionStampRepository {
  Future<Result<List<DiaryDetailData>>> getEmotionStamp(String from, String to);
}
