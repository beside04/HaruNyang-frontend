import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/domain/model/emoticon_weather/emoticon_data.dart';
import 'package:frontend/domain/model/emoticon_weather/weather_data.dart';
import 'package:frontend/providers/diary/model/diary_select_state.dart';

final diarySelectProvider = StateNotifierProvider<DiarySelectNotifier, DiarySelectState>((ref) {
  return DiarySelectNotifier(
    ref,
  );
});

class DiarySelectNotifier extends StateNotifier<DiarySelectState> {
  DiarySelectNotifier(this.ref) : super(DiarySelectState());

  final Ref ref;

  void popDownEmotionModal() {
    state = state.copyWith(isEmotionModal: false);
  }

  void popUpEmotionModal() {
    state = state.copyWith(isEmotionModal: true);
  }

  getEmotionValue() {
    if (state.emotionNumberValue < 1.0) {
      state = state.copyWith(emotionTextValue: '조금?');
    } else if (state.emotionNumberValue < 2.0) {
      state = state.copyWith(emotionTextValue: '그럭저럭');
    } else if (state.emotionNumberValue < 3.0) {
      state = state.copyWith(emotionTextValue: '맞아!');
    } else {
      state = state.copyWith(emotionTextValue: '진짜 엄청 대박!!');
    }
  }

  void setSelectedEmoticon(EmoticonData emoticon) {
    state = state.copyWith(selectedEmotion: emoticon);
  }

  void setSelectedWeather(WeatherData weather) {
    state = state.copyWith(selectedWeather: weather);
  }
}
