import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/domains/font/model/font_state.dart';

final fontProvider = StateNotifierProvider<FontNotifier, FontState>((ref) {
  return FontNotifier(
    ref,
  );
});

class FontNotifier extends StateNotifier<FontState> {
  FontNotifier(this.ref) : super(FontState());

  final Ref ref;

  TextStyle getFontStyle() {
    return TextStyle(
      fontFamily: state.selectedFontValue,
      fontSize: state.changedFontSize,
      height: state.changedFontHeight,
    );
  }

  handleChangeFont(Font font) {
    state = state.copyWith(
      selectedFontTitle: font.title,
      selectedFontValue: font.value,
      selectedFontDefaultSize: font.size,
      changedFontSize: font.size,
      selectedFontDefaultHeight: font.height,
      changedFontHeight: font.height,
    );
  }

  handleSetDefaultFontSize() {
    state = state.copyWith(
      changedFontSize: state.selectedFontDefaultSize,
      changedFontHeight: state.selectedFontDefaultHeight,
    );
  }

  handleUpFontSize() {
    double newFontHeight = calculateLineHeight(state.selectedFontDefaultSize + 2, true);

    state = state.copyWith(
      changedFontSize: state.selectedFontDefaultSize + 2,
      changedFontHeight: newFontHeight,
    );
  }

  handleDownFontSize() {
    double newFontHeight = calculateLineHeight(state.selectedFontDefaultSize - 2, false);

    state = state.copyWith(
      changedFontSize: state.selectedFontDefaultSize - 2,
      changedFontHeight: newFontHeight,
    );
  }

  double calculateLineHeight(double fontSize, bool isFontSizeUp) {
    switch (state.selectedFontValue) {
      case 'pretendard':
        {
          return fontSize == 16
              ? state.selectedFontDefaultHeight
              : isFontSizeUp
                  ? state.selectedFontDefaultHeight - 0.23
                  : state.selectedFontDefaultHeight + 0.3;
        }
      case 'nanum_ddaacdandan':
        {
          return fontSize == 20
              ? state.selectedFontDefaultHeight
              : isFontSizeUp
                  ? state.selectedFontDefaultHeight - 0.15
                  : state.selectedFontDefaultHeight + 0.2;
        }
      case 'leeSeoyun':
        {
          return fontSize == 16
              ? state.selectedFontDefaultHeight
              : isFontSizeUp
                  ? state.selectedFontDefaultHeight - 0.23
                  : state.selectedFontDefaultHeight + 0.3;
        }
      case 'maruburi':
        {
          return fontSize == 16
              ? state.selectedFontDefaultHeight
              : isFontSizeUp
                  ? state.selectedFontDefaultHeight - 0.23
                  : state.selectedFontDefaultHeight + 0.3;
        }
      case 'nanum_junghacsang':
        {
          return fontSize == 20
              ? state.selectedFontDefaultHeight
              : isFontSizeUp
                  ? state.selectedFontDefaultHeight - 0.23
                  : state.selectedFontDefaultHeight + 0.2;
        }
      case 'nanum_bisang':
        {
          return fontSize == 20
              ? state.selectedFontDefaultHeight
              : isFontSizeUp
                  ? state.selectedFontDefaultHeight - 0.23
                  : state.selectedFontDefaultHeight + 0.2;
        }
      default:
        {
          return state.selectedFontDefaultHeight;
        }
    }
  }
}
