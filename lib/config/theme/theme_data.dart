import 'package:flutter/material.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';

ThemeData lightMode = ThemeData(
  scaffoldBackgroundColor: kWhiteColor,
  bottomAppBarColor: const Color(0xfff6f5f4),
  primaryColor: kPrimaryColor,
  unselectedWidgetColor: kGrayColor400,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    unselectedItemColor: kGrayColor400,
    selectedItemColor: kBlackColor,
    selectedLabelStyle: kBody2BlackStyle,
    unselectedLabelStyle: kBody2BlackStyle,
    selectedIconTheme: const IconThemeData(color: kBlackColor),
    unselectedIconTheme: const IconThemeData(color: kGrayColor400),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: kSuccessColor,
  ),
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    backgroundColor: kWhiteColor,
    iconTheme: IconThemeData(
      color: kBlackColor,
    ),
  ),
  //primarySwatch: Colors.blue,
  textTheme: TextTheme(
    headline1: kHeader1BlackStyle,
    headline2: kHeader2BlackStyle,
    headline3: kHeader3BlackStyle,
    headline4: kHeader4BlackStyle,
    headline5: kHeader5BlackStyle,
    headline6: kHeader6BlackStyle,
    subtitle1: kSubtitle1BlackStyle,
    subtitle2: kSubtitle2Gray400Style,
    bodyText1: kBody1BlackStyle,
    bodyText2: kBody2BlackStyle,
    caption: kCaption1BlackStyle,
  ),
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

ThemeData darkMode = ThemeData(
  scaffoldBackgroundColor: kGrayColor950,
  bottomAppBarColor: kGrayColor950,
  primaryColor: kPrimaryColor,
  unselectedWidgetColor: kGrayColor600,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    unselectedItemColor: kGrayColor600,
    selectedItemColor: kWhiteColor,
    selectedLabelStyle: kBody2WhiteStyle,
    unselectedLabelStyle: kBody2WhiteStyle,
    selectedIconTheme: const IconThemeData(color: kWhiteColor),
    unselectedIconTheme: const IconThemeData(color: kGrayColor600),
  ),
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    backgroundColor: kGrayColor950,
    iconTheme: IconThemeData(
      color: kWhiteColor,
    ),
  ),
  brightness: Brightness.dark,
  textTheme: TextTheme(
    headline1: kHeader1WhiteStyle,
    headline2: kHeader2WhiteStyle,
    headline3: kHeader3WhiteStyle,
    headline4: kHeader4WhiteStyle,
    headline5: kHeader5WhiteStyle,
    headline6: kHeader6WhiteStyle,
    subtitle1: kSubtitle1WhiteStyle,
    subtitle2: kSubtitle2Gray600Style,
    bodyText1: kBody1WhiteStyle,
    bodyText2: kBody2WhiteStyle,
    caption: kCaption1WhiteStyle,
  ),
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
  Color get darkTheme_00_700 =>
      brightness == Brightness.light ? kWhiteColor : kGrayColor700;
  Color get darkTheme_00_900 =>
      brightness == Brightness.light ? kWhiteColor : kGrayColor900;
  Color get darkTheme_00_950 =>
      brightness == Brightness.light ? kWhiteColor : kGrayColor950;
  Color get darkTheme_50_700 =>
      brightness == Brightness.light ? kGrayColor50 : kGrayColor700;
  Color get darkTheme_50_850 =>
      brightness == Brightness.light ? kGrayColor50 : kGrayColor850;
  Color get darkTheme_50_900 =>
      brightness == Brightness.light ? kGrayColor50 : kGrayColor900;
  Color get darkTheme_100_650 =>
      brightness == Brightness.light ? kGrayColor100 : kGrayColor650;
  Color get darkTheme_100_700 =>
      brightness == Brightness.light ? kGrayColor100 : kGrayColor700;
  Color get darkTheme_100_850 =>
      brightness == Brightness.light ? kGrayColor100 : kGrayColor850;
  Color get darkTheme_200_900 =>
      brightness == Brightness.light ? kGrayColor200 : kGrayColor900;
  Color get darkTheme_200_950 =>
      brightness == Brightness.light ? kGrayColor200 : kGrayColor950;
  Color get darkTheme_250_850 =>
      brightness == Brightness.light ? kGrayColor250 : kGrayColor850;
  Color get darkTheme_250_900 =>
      brightness == Brightness.light ? kGrayColor250 : kGrayColor900;
}
