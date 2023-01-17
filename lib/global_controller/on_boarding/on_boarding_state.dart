import 'package:freezed_annotation/freezed_annotation.dart';

part 'on_boarding_state.freezed.dart';

part 'on_boarding_state.g.dart';

@freezed
class OnBoardingState with _$OnBoardingState {
  factory OnBoardingState({
    @Default('') String job,
    @Default('') String age,
    @Default('') String socialId,
    @Default('') String nickname,
    @Default('') String loginType,
    String? email,
  }) = _OnBoardingState;

  factory OnBoardingState.fromJson(Map<String, dynamic> json) =>
      _$OnBoardingStateFromJson(json);
}
