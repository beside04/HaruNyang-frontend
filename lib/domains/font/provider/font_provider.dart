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
      changedFontHeight: font.height,
    );
  }

  handleSetDefaultFontSize() {
    state = state.copyWith(changedFontSize: state.selectedFontDefaultSize);
  }

  handleUpFontSize() {
    state = state.copyWith(changedFontSize: state.selectedFontDefaultSize + 2);
  }

  handleDownFontSize() {
    state = state.copyWith(changedFontSize: state.selectedFontDefaultSize - 2);
  }
}
