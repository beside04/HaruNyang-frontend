import 'package:frontend/apis/response_result.dart';
import 'package:frontend/domain/model/diary/diary_detail_data.dart';

abstract class EmotionStampRepository {
  Future<ResponseResult<List<DiaryDetailData>>> getEmotionStamp(String from, String to);
}
