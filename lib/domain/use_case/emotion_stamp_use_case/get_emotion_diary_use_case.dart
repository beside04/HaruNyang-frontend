import 'package:frontend/core/result.dart';
import 'package:frontend/domain/model/diary/diary_data.dart';
import 'package:frontend/domain/repository/emotion_stamp/emotion_stamp_repository.dart';

class GetEmotionStampUseCase {
  final EmotionStampRepository emotionStampRepository;
  late Function(List<DiaryData>)? _callback;
  late String _defaultStartDate;
  late String _defaultEndDate;

  GetEmotionStampUseCase({
    required this.emotionStampRepository,
  });

  Future<Result<List<DiaryData>>> call(String from, String to) async {
    final result = await emotionStampRepository.getEmotionStamp(from, to);
    result.when(
        success: (result) {
          if (_callback != null) {
            _callback!(result);
          }
        },
        error: (message) {});
    return result;
  }

  void registerCallback(Function(List<DiaryData>) func) {
    _callback = func;
  }

  void setDefaultDate(String start, String end) {
    _defaultStartDate = start;
    _defaultEndDate = end;
  }

  Future<void> getEmoticonStampByDefault() async {
    final result = await emotionStampRepository.getEmotionStamp(
        _defaultStartDate, _defaultEndDate);
    result.when(
        success: (result) {
          if (_callback != null) {
            _callback!(result);
          }
        },
        error: (message) {});
  }
}
