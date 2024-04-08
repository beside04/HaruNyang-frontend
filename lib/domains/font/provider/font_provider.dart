import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/utils/utils.dart';
import 'package:frontend/domains/font/model/font_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

final fontProvider = StateNotifierProvider<FontNotifier, FontState>((ref) {
  return FontNotifier(
    ref,
  );
});

class FontNotifier extends StateNotifier<FontState> {
  FontNotifier(this.ref) : super(FontState()) {
    _loadFontSettings();
  }

  final Ref ref;

  Future<void> _loadFontSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final selectedFontTitle = prefs.getString('selectedFontTitle') ?? '시스템 폰트(Pretendard)';
    final selectedFontValue = prefs.getString('selectedFontValue') ?? 'pretendard';
    final selectedFontSize = prefs.getDouble('selectedFontSize') ?? 16.0;
    final selectedFontHeight = prefs.getDouble('selectedFontHeight') ?? 2.1;
    final selectedFontDefaultSize = prefs.getDouble('selectedFontDefaultSize') ?? 16.0;
    final selectedFontDefaultHeight = prefs.getDouble('selectedFontDefaultHeight') ?? 2.1;

    if (selectedFontValue.isNotEmpty) {
      state = state.copyWith(
        selectedFontTitle: selectedFontTitle,
        selectedFontValue: selectedFontValue,
        selectedFontDefaultSize: selectedFontDefaultSize,
        changedFontSize: selectedFontSize,
        selectedFontDefaultHeight: selectedFontDefaultHeight,
        changedFontHeight: selectedFontHeight,
      );
    }
  }

  TextStyle getFontStyle() {
    return TextStyle(
      fontFamily: state.selectedFontValue,
      fontSize: state.changedFontSize,
      height: state.changedFontHeight,
    );
  }

  handleChangeFont(Font font) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('selectedFontTitle', font.title);
    await prefs.setString('selectedFontValue', font.value);
    await prefs.setDouble('selectedFontSize', font.size);
    await prefs.setDouble('selectedFontHeight', font.height);

    GlobalUtils.setAnalyticsCustomEvent('Click_Font_Change_${font.title}');

    state = state.copyWith(
      selectedFontTitle: font.title,
      selectedFontValue: font.value,
      selectedFontDefaultSize: font.size,
      changedFontSize: font.size,
      selectedFontDefaultHeight: font.height,
      changedFontHeight: font.height,
    );
  }

  handleSetDefaultFontSize() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble('selectedFontSize', state.selectedFontDefaultSize);
    await prefs.setDouble('selectedFontHeight', state.selectedFontDefaultHeight);
    await prefs.setDouble('selectedFontDefaultSize', state.selectedFontDefaultSize);
    await prefs.setDouble('selectedFontDefaultHeight', state.selectedFontDefaultHeight);

    GlobalUtils.setAnalyticsCustomEvent('Click_Font_Scale_Default');

    state = state.copyWith(
      changedFontSize: state.selectedFontDefaultSize,
      changedFontHeight: state.selectedFontDefaultHeight,
    );
  }

  handleUpFontSize() async {
    double newFontHeight = calculateLineHeight(state.selectedFontDefaultSize + 2, true);

    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble('selectedFontSize', state.selectedFontDefaultSize + 2);
    await prefs.setDouble('selectedFontHeight', newFontHeight);
    await prefs.setDouble('selectedFontDefaultSize', state.selectedFontDefaultSize);
    await prefs.setDouble('selectedFontDefaultHeight', calculateLineHeight(state.selectedFontDefaultSize, true));

    GlobalUtils.setAnalyticsCustomEvent('Click_Font_Scale_Big');
    state = state.copyWith(
      changedFontSize: state.selectedFontDefaultSize + 2,
      changedFontHeight: newFontHeight,
    );
  }

  handleDownFontSize() async {
    double newFontHeight = calculateLineHeight(state.selectedFontDefaultSize - 2, false);

    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble('selectedFontSize', state.selectedFontDefaultSize - 2);
    await prefs.setDouble('selectedFontHeight', newFontHeight);
    await prefs.setDouble('selectedFontDefaultSize', state.selectedFontDefaultSize);
    await prefs.setDouble('selectedFontDefaultHeight', calculateLineHeight(state.selectedFontDefaultSize, false));

    GlobalUtils.setAnalyticsCustomEvent('Click_Font_Scale_Small');

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
                  ? state.selectedFontDefaultHeight - 0.15
                  : state.selectedFontDefaultHeight + 0.2;
        }
      case 'nanum_bisang':
        {
          return fontSize == 20
              ? state.selectedFontDefaultHeight
              : isFontSizeUp
                  ? state.selectedFontDefaultHeight - 0.15
                  : state.selectedFontDefaultHeight + 0.2;
        }
      default:
        {
          return state.selectedFontDefaultHeight;
        }
    }
  }
}
