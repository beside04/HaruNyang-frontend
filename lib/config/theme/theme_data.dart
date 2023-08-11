import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';

ThemeData lightMode(context) => ThemeData(
      scrollbarTheme: ScrollbarThemeData(
        thumbColor:
            MaterialStateProperty.all(const Color(0xffd9d9d9)), // 원하는 색상으로 변경
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        side: MaterialStateBorderSide.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const BorderSide(width: 1.0, color: kOrange300Color);
          } else {
            return const BorderSide(width: 1.0, color: Color(0xffdfdfdf));
          }
        }),
      ),
      scaffoldBackgroundColor: kWhiteColor,
      bottomAppBarTheme: const BottomAppBarTheme(color: kWhiteColor),
      primaryColor: kOrange300Color,
      unselectedWidgetColor: kGrayColor400,
      popupMenuTheme: PopupMenuThemeData(
        elevation: 4.0,
        shadowColor: kBlackColor.withOpacity(0.3),
      ),
      dividerTheme: const DividerThemeData(
        color: kGrayColor100,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: kWhiteColor,
        unselectedItemColor: kGrayColor400,
        selectedItemColor: kBlackColor,
        selectedLabelStyle: kCaption2Style,
        unselectedLabelStyle: kCaption2Style,
        selectedIconTheme: const IconThemeData(color: kBlackColor),
        unselectedIconTheme: const IconThemeData(color: kGrayColor400),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: kBlue300Color,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: kWhiteColor,
        shadowColor: kGrayColor200,
        iconTheme: const IconThemeData(
          color: kGrayColor950,
        ),
        titleTextStyle: kHeader3Style,
        toolbarHeight: 48.h,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Colors.transparent,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kGrayColor100),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kGrayColor950),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kRed300Color),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kRed300Color),
        ),
      ),
    );

ThemeData darkMode(context) => ThemeData(
      scrollbarTheme: ScrollbarThemeData(
        thumbColor:
            MaterialStateProperty.all(const Color(0xffd9d9d9)), // 원하는 색상으로 변경
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        side: MaterialStateBorderSide.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const BorderSide(width: 1.0, color: kOrange300Color);
          } else {
            return const BorderSide(width: 1.0, color: Color(0xffdfdfdf));
          }
        }),
      ),
      scaffoldBackgroundColor: kGrayColor950,
      bottomAppBarTheme: const BottomAppBarTheme(color: kGrayColor950),
      primaryColor: kOrange300Color,
      unselectedWidgetColor: kGrayColor600,
      popupMenuTheme: PopupMenuThemeData(
        elevation: 4.0,
        shadowColor: kBlackColor.withOpacity(0.3),
      ),
      dividerTheme: const DividerThemeData(
        color: kGrayColor900,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: kGrayColor950,
        unselectedItemColor: kGrayColor600,
        selectedItemColor: kWhiteColor,
        selectedLabelStyle: kBody3Style.copyWith(color: kWhiteColor),
        unselectedLabelStyle: kBody3Style.copyWith(color: kWhiteColor),
        selectedIconTheme: const IconThemeData(color: kWhiteColor),
        unselectedIconTheme: const IconThemeData(color: kGrayColor600),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: kGrayColor950,
        shadowColor: kGrayColor850,
        iconTheme: const IconThemeData(
          color: kGrayColor50,
        ),
        toolbarHeight: 48.h,
      ),
      brightness: Brightness.dark,
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Colors.transparent,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kGrayColor800),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kGrayColor50),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kRed200Color),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kRed200Color),
        ),
      ),
    );

extension CustomColorScheme on ColorScheme {
  Color get backgroundColor =>
      brightness == Brightness.light ? kWhiteColor : kGrayColor950;
  Color get backgroundModal =>
      brightness == Brightness.light ? kWhiteColor : kGrayColor900;
  Color get surface_01 =>
      brightness == Brightness.light ? kGrayColor50 : kGrayColor900;
  Color get surface_02 =>
      brightness == Brightness.light ? kGrayColor100 : kGrayColor850;
  Color get surfaceModal =>
      brightness == Brightness.light ? kGrayColor50 : kGrayColor850;
  Color get primaryColor =>
      brightness == Brightness.light ? kOrange300Color : kOrange200Color;
  Color get secondaryColor =>
      brightness == Brightness.light ? kGrayColor100 : kGrayColor800;
  Color get errorColor =>
      brightness == Brightness.light ? kRed300Color : kRed200Color;
  Color get successColor =>
      brightness == Brightness.light ? kBlue300Color : kBlue200Color;
  Color get disabledColor =>
      brightness == Brightness.light ? kGrayColor150 : kGrayColor850;
  Color get textPrimary =>
      brightness == Brightness.light ? kOrange350Color : kOrange250Color;
  Color get textTitle =>
      brightness == Brightness.light ? kGrayColor950 : kGrayColor50;
  Color get textSubtitle =>
      brightness == Brightness.light ? kGrayColor500 : kGrayColor400;
  Color get textBody =>
      brightness == Brightness.light ? kGrayColor800 : kGrayColor100;
  Color get textLowEmphasis =>
      brightness == Brightness.light ? kGrayColor400 : kGrayColor550;
  Color get textCaption =>
      brightness == Brightness.light ? kGrayColor700 : kGrayColor300;
  Color get textDisabled =>
      brightness == Brightness.light ? kGrayColor300 : kGrayColor700;
  Color get placeHolder =>
      brightness == Brightness.light ? kGrayColor400 : kGrayColor550;
  Color get iconColor =>
      brightness == Brightness.light ? kGrayColor950 : kGrayColor50;
  Color get iconColorReverse =>
      brightness == Brightness.light ? kGrayColor50 : kGrayColor950;
  Color get iconSubColor =>
      brightness == Brightness.light ? kGrayColor400 : kGrayColor600;
  Color get border =>
      brightness == Brightness.light ? kGrayColor100 : kGrayColor850;
  Color get borderModal =>
      brightness == Brightness.light ? kGrayColor250 : kGrayColor900;
  Color get outlineDefault =>
      brightness == Brightness.light ? kGrayColor250 : kGrayColor800;
  Color get outlineChip =>
      brightness == Brightness.light ? kGrayColor50 : kGrayColor850;
  Color get outlineActive =>
      brightness == Brightness.light ? kGrayColor950 : kGrayColor50;
  Color get backgroundListColor =>
      brightness == Brightness.light ? kWhiteColor : kGrayColor900;
}
