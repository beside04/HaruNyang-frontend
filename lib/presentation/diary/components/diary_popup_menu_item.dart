import 'package:flutter/material.dart';

PopupMenuItem diaryPopUpMenuItem(
  String title,
  String value,
  BuildContext context,
) {
  return PopupMenuItem(
    value: title,
    child: Center(
      child: Text(
        value,
        style: Theme.of(context).textTheme.headline6,
      ),
    ),
  );
}
