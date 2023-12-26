import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/domain/model/topic/topic_data.dart';

part 'write_diary_state.freezed.dart';
part 'write_diary_state.g.dart';

@freezed
class WriteDiaryState with _$WriteDiaryState {
  factory WriteDiaryState({
    @Default('') String diaryValue,
    @Default(null) String? networkImage,
    @Default(0) int diaryValueLength,
    @Default('') String firebaseImageUrl,
    @Default(false) bool isUpdated,
    @Default(1) int randomImageNumber,
    @Default(TopicData(
      id: 0,
      value: '',
    ))
    TopicData topic,
    @Default(false) bool shouldShowWidget,
    @Default([
      TopicData(
        id: 9,
        value: '오늘 가장 기억에 남는 일은\n 무엇이었나요?',
      ),
      TopicData(
        id: 10,
        value: '요즘 힘든 점이\n 있어요?',
      ),
      TopicData(
        id: 11,
        value: '고민거리가\n 뭐예요?',
      ),
      TopicData(
        id: 12,
        value: '오늘 점심은\n 뭘 먹었어요?',
      ),
      TopicData(
        id: 13,
        value: '다가오는 주말에\n 뭘 할거예요?',
      ),
      TopicData(
        id: 14,
        value: '오늘 가장 재밌는 일은\n 뭐였어요?',
      ),
      TopicData(
        id: 15,
        value: '오늘 어떤 커피를\n 먹었어요?',
      ),
      TopicData(
        id: 16,
        value: '무엇이 나를\n 힘들게 해요?',
      ),
      TopicData(
        id: 17,
        value: '무엇이 나를\n 설레게 해요?',
      ),
      TopicData(
        id: 18,
        value: '내일 하고\n 싶은게 뭐예요?',
      ),
      TopicData(
        id: 19,
        value: '요즘 자주 듣는\n 음악이 뭐예요?',
      ),
      TopicData(
        id: 20,
        value: '먹고 싶은 음식이\n 있나요?',
      ),
      TopicData(
        id: 21,
        value: '지금 받고 싶은\n 선물이 뭐예요?',
      ),
      TopicData(
        id: 22,
        value: '쉬는 날에\n 어디 가고 싶어요?',
      ),
    ])
    List<TopicData> metaTopic,
  }) = _WriteDiaryState;

  factory WriteDiaryState.fromJson(Map<String, dynamic> json) => _$WriteDiaryStateFromJson(json);
}
