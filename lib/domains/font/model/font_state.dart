import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'font_state.freezed.dart';
part 'font_state.g.dart';

class Font {
  String title;
  String value;
  double size;
  double height;

  Font({
    required this.title,
    required this.value,
    required this.size,
    required this.height,
  });
}

@freezed
class FontState with _$FontState {
  factory FontState({
    @Default('시스템폰트(Pretendard)') String selectedFontTitle,
    @Default('pretendard') String selectedFontValue,
    @Default(16.0) double selectedFontDefaultSize,
    @Default(16.0) double changedFontSize,
    @Default(2.1) double changedFontHeight,
  }) = _FontState;

  FontState._();

  TextStyle get fontStyle {
    return TextStyle(
      fontFamily: selectedFontValue,
      fontSize: changedFontSize,
      height: changedFontHeight,
    );
  }

  factory FontState.fromJson(Map<String, dynamic> json) =>
      _$FontStateFromJson(json);
}
