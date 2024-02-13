import 'package:freezed_annotation/freezed_annotation.dart';

part 'font_state.freezed.dart';
part 'font_state.g.dart';

class Font {
  String title;
  String value;
  double size;

  Font(this.title, this.value, this.size);
}

@freezed
class FontState with _$FontState {
  factory FontState({
    @Default('시스템폰트(Pretendard)') String selectedFontTitle,
    @Default('pretendard') String selectedFontValue,
    @Default(16.0) double selectedFontDefaultSize,
    @Default(16.0) double changedFontSize,
  }) = _FontState;

  factory FontState.fromJson(Map<String, dynamic> json) =>
      _$FontStateFromJson(json);
}
