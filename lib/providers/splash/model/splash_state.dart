import 'package:freezed_annotation/freezed_annotation.dart';

part 'splash_state.freezed.dart';
part 'splash_state.g.dart';

@freezed
class SplashState with _$SplashState {
  factory SplashState({
    @Default(0) int selectedIndex,
    @Default(false) bool isOpenPopup,
    @Default(false) bool isNeedUpdate,
    String? lastPopupDate,
    String? lastBirthDayPopupDate,
  }) = _SplashState;

  factory SplashState.fromJson(Map<String, dynamic> json) => _$SplashStateFromJson(json);
}
