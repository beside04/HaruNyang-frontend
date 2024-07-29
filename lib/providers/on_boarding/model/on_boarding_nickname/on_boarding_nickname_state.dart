import 'package:freezed_annotation/freezed_annotation.dart';

part 'on_boarding_nickname_state.freezed.dart';

part 'on_boarding_nickname_state.g.dart';

@freezed
class OnBoardingNicknameState with _$OnBoardingNicknameState {
  factory OnBoardingNicknameState({
    @Default(false) bool isOnKeyboard,
  }) = _OnBoardingNicknameState;

  factory OnBoardingNicknameState.fromJson(Map<String, dynamic> json) => _$OnBoardingNicknameStateFromJson(json);
}
