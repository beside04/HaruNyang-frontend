import 'package:frontend/apis/response_result.dart';
import 'package:frontend/domain/model/diary/diary_detail_data.dart';
import 'package:frontend/domain/repository/emotion_stamp/emotion_stamp_repository.dart';
import 'package:intl/intl.dart';

class GetEmotionStampUseCase {
  final EmotionStampRepository emotionStampRepository;

  GetEmotionStampUseCase({
    required this.emotionStampRepository,
  });

  Future<ResponseResult<List<DiaryDetailData>>> call(String from, String to) async {
    final result = await emotionStampRepository.getEmotionStamp(from, to);
    result.when(
      success: (result) {},
      error: (message) {},
    );
    return result;
  }

  Future<ResponseResult<List<DiaryDetailData>>> getTodayDiary() async {
    DateTime today = DateTime.now();
    DateTime tomorrow = today.add(const Duration(days: 1));

    String start = DateFormat('yyyy-MM-dd').format(today);
    String end = DateFormat('yyyy-MM-dd').format(tomorrow);

    final result = await emotionStampRepository.getEmotionStamp(start, end);

    return result;
  }

  Future<bool> hasTodayDiary() async {
    bool returnValue = false;
    final result = await getTodayDiary();
    result.when(
      success: (data) {
        if (data.isNotEmpty) {
          returnValue = true;
        }
      },
      error: (message) {},
    );

    return returnValue;
  }
}
