import 'package:flutter/material.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';

ThemeData lightMode = ThemeData(
  scaffoldBackgroundColor: kWhiteColor,
  bottomAppBarColor: Color(0xfff6f5f4),
  primaryColor: kPrimaryColor,
  colorScheme: const ColorScheme(
    primary: kWhiteColor,
    secondary: Color(0xfff6f5f4),
    brightness: Brightness.light,
    onPrimary: kWhiteColor,
    onSecondary: kWhiteColor,
    error: kWhiteColor,
    onError: kWhiteColor,
    background: kWhiteColor,
    onBackground: kWhiteColor,
    surface: kGrayColor100,
    onSurface: kWhiteColor,
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
  primarySwatch: Colors.blue,
  textTheme: TextTheme(
    headline1: kHeader1BlackStyle,
    headline2: kHeader2BlackStyle,
    headline3: kHeader3BlackStyle,
    headline4: kHeader4BlackStyle,
    headline5: kHeader5BlackStyle,
    headline6: kHeader6BlackStyle,
    subtitle1: kSubtitle1BlackStyle,
    bodyText1: kBody1BlackStyle,
    bodyText2: kBody2BlackStyle,
    caption: kCaption1BlackStyle,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: kGrayColor50,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: kGrayColor100),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: kGrayColor950),
    ),
  ),
);

ThemeData darkMode = ThemeData(
  scaffoldBackgroundColor: kGrayColor950,
  bottomAppBarColor: kGrayColor950,
  primaryColor: kPrimaryColor,
  colorScheme: const ColorScheme(
    primary: kGrayColor900,
    secondary: kGrayColor800,
    brightness: Brightness.dark,
    onPrimary: kGrayColor900,
    onSecondary: kGrayColor800,
    error: kGrayColor900,
    onError: kGrayColor900,
    background: kGrayColor900,
    onBackground: kGrayColor900,
    surface: kGrayColor700,
    onSurface: kGrayColor900,
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: kSuccessColor,
  ),
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    backgroundColor: kGrayColor950,
    iconTheme: IconThemeData(
      color: kWhiteColor,
    ),
  ),
  brightness: Brightness.dark,
  primarySwatch: Colors.blue,
  textTheme: TextTheme(
    headline1: kHeader1WhiteStyle,
    headline2: kHeader2WhiteStyle,
    headline3: kHeader3WhiteStyle,
    headline4: kHeader4WhiteStyle,
    headline5: kHeader5WhiteStyle,
    headline6: kHeader6WhiteStyle,
    subtitle1: kSubtitle1BlackStyle,
    bodyText1: kBody1WhiteStyle,
    bodyText2: kBody2WhiteStyle,
    caption: kCaption1WhiteStyle,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: kGrayColor50,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: kGrayColor100),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: kGrayColor950),
    ),
  ),
);
