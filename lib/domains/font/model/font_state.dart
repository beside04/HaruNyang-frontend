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
    @Default(2.1) double selectedFontDefaultHeight,
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

  double get lineHeight {
    switch (selectedFontValue) {
      case 'pretendard':
        {
          return changedFontSize == 16
              ? selectedFontDefaultHeight
              : changedFontSize > selectedFontDefaultSize
                  ? 2
                  : 2.5;
        }
      case 'nanum_ddaacdandan':
        {
          return changedFontSize == 20
              ? selectedFontDefaultHeight
              : changedFontSize > selectedFontDefaultSize
                  ? 1.5
                  : 1.8;
        }
      case 'leeSeoyun':
        {
          return changedFontSize == 16
              ? selectedFontDefaultHeight
              : changedFontSize > selectedFontDefaultSize
                  ? 1.8
                  : 2.25;
        }
      case 'maruburi':
        {
          return changedFontSize == 16
              ? selectedFontDefaultHeight
              : changedFontSize > selectedFontDefaultSize
                  ? 1.75
                  : 3;
        }
      case 'nanum_junghacsang':
        {
          return changedFontSize == 20
              ? selectedFontDefaultHeight
              : changedFontSize > selectedFontDefaultSize
                  ? 1.5
                  : 1.8;
        }
      case 'nanum_bisang':
        {
          return changedFontSize == 20
              ? selectedFontDefaultHeight
              : changedFontSize > selectedFontDefaultSize
                  ? 1.38
                  : 1.6;
        }
      default:
        {
          return selectedFontDefaultHeight;
        }
    }
  }

  factory FontState.fromJson(Map<String, dynamic> json) =>
      _$FontStateFromJson(json);
}
