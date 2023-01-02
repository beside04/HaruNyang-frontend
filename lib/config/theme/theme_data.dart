import 'package:flutter/material.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';

ThemeData lightMode = ThemeData(
  scaffoldBackgroundColor: kWhiteColor,
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
    headline2: kHeader2WhiteStyle,
    headline1: kHeader1WhiteStyle,
    headline3: kHeader3WhiteStyle,
    headline4: kHeader4WhiteStyle,
    headline5: kHeader5WhiteStyle,
    headline6: kHeader6WhiteStyle,
    subtitle1: kSubtitle1WhiteStyle,
    bodyText1: kBody1WhiteStyle,
    bodyText2: kBody2WhiteStyle,
    caption: kCaption1WhiteStyle,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: kGrayColor50,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: kGrayColor150),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: kGrayColor950),
    ),
  ),
);

ThemeData darkMode = ThemeData(
  scaffoldBackgroundColor: kGrayColor900,
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: kSuccessColor,
  ),
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    backgroundColor: kGrayColor900,
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
      borderSide: BorderSide(color: kGrayColor150),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: kGrayColor950),
    ),
  ),
);
