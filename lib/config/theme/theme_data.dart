import 'package:flutter/material.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';

ThemeData lightMode(context) => ThemeData(
      scaffoldBackgroundColor: kBeigeColor100,
      bottomAppBarColor: kBeigeColor100,
      primaryColor: kOrange300Color,
      unselectedWidgetColor: kGrayColor400,
      dividerTheme: const DividerThemeData(
        color: kBeigeColor200,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: kBeigeColor100,
        unselectedItemColor: kGrayColor400,
        selectedItemColor: kBlackColor,
        selectedLabelStyle: kBody2Style,
        unselectedLabelStyle: kBody2Style,
        selectedIconTheme: const IconThemeData(color: kBlackColor),
        unselectedIconTheme: const IconThemeData(color: kGrayColor400),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: kBlue300Color,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: kBeigeColor100,
        iconTheme: const IconThemeData(
          color: kGrayColor950,
        ),
        titleTextStyle: kHeader3Style,
      ),
      //primarySwatch: Colors.blue,
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Colors.transparent,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kGrayColor100),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kGrayColor100),
        ),
      ),
    );

ThemeData darkMode(context) => ThemeData(
      scaffoldBackgroundColor: kGrayColor950,
      bottomAppBarColor: kGrayColor950,
      primaryColor: kOrange300Color,
      unselectedWidgetColor: kGrayColor600,
      dividerTheme: const DividerThemeData(
        color: kGrayColor900,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: kGrayColor950,
        unselectedItemColor: kGrayColor600,
        selectedItemColor: kWhiteColor,
        selectedLabelStyle: kBody2Style.copyWith(color: kWhiteColor),
        unselectedLabelStyle: kBody2Style.copyWith(color: kWhiteColor),
        selectedIconTheme: const IconThemeData(color: kWhiteColor),
        unselectedIconTheme: const IconThemeData(color: kGrayColor600),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: kGrayColor950,
        iconTheme: IconThemeData(
          color: kGrayColor50,
        ),
      ),
      brightness: Brightness.dark,
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Colors.transparent,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kGrayColor750),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kGrayColor750),
        ),
      ),
    );

extension CustomColorScheme on ColorScheme {
  Color get backgroundColor =>
      brightness == Brightness.light ? kBeigeColor100 : kGrayColor950;
  Color get backgroundModal =>
      brightness == Brightness.light ? kWhiteColor : kGrayColor900;
  Color get surface_01 =>
      brightness == Brightness.light ? kBeigeColor200 : kGrayColor900;
  Color get surface_02 =>
      brightness == Brightness.light ? kBeigeColor300 : kGrayColor850;
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
      brightness == Brightness.light ? kGrayColor950 : kGrayColor50;
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
  Color get iconSubColor =>
      brightness == Brightness.light ? kGrayColor400 : kGrayColor600;
  Color get border =>
      brightness == Brightness.light ? kGrayColor200 : kGrayColor850;
  Color get borderModal =>
      brightness == Brightness.light ? kGrayColor250 : kGrayColor900;
  Color get outlineDefault =>
      brightness == Brightness.light ? kGrayColor250 : kGrayColor800;
  Color get outlineChip =>
      brightness == Brightness.light ? kGrayColor50 : kGrayColor850;
  Color get outlineActive =>
      brightness == Brightness.light ? kGrayColor950 : kGrayColor50;
}

/// Global variables
/// * [GlobalKey<NavigatorState>]
class CandyGlobalVariable {
  static final GlobalKey<NavigatorState> naviagatorState =
      GlobalKey<NavigatorState>();
}
