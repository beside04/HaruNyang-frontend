import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';

PopupMenuItem diaryPopUpMenuItem(
  String title,
  String value,
  BuildContext context,
  Widget widget,
) {
  return PopupMenuItem(
    value: title,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: kHeader6Style.copyWith(
                color: Theme.of(context).colorScheme.textTitle),
          ),
          SizedBox(
            width: 20.w,
          ),
          widget,
        ],
      ),
    ),
  );
}
