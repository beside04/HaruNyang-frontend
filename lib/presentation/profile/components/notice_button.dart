import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:intl/intl.dart';

class NoticeButton extends StatelessWidget {
  const NoticeButton({
    super.key,
    required this.title,
    required this.date,
    required this.isImportant,
    required this.onPressed,
  });

  final String title;
  final DateTime date;
  final bool isImportant;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).colorScheme.border,
              width: 1.0,
            ),
          ),
        ),
        child: Padding(
          padding: kPrimaryPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: kHeader6Style.copyWith(
                            color: Theme.of(context).colorScheme.textBody),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(width: 12.0.w),
                      isImportant
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.w),
                                color: kOrange200Color,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 4.0.h, horizontal: 6.0.w),
                                child: Text(
                                  '중요',
                                  style: kCaption1Style.copyWith(
                                      color: kWhiteColor),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  Text(
                    DateFormat('yyyy.MM.dd').format(date),
                    style: kBody2Style.copyWith(
                        color: Theme.of(context).colorScheme.textLowEmphasis),
                  ),
                ],
              ),
              Icon(
                Icons.navigate_next,
                color: Theme.of(context).colorScheme.iconSubColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
