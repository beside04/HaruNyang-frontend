import 'package:flutter/material.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';

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
        style: kHeader6Style.copyWith(
            color: Theme.of(context).colorScheme.textTitle),
      ),
    ),
  );
}
