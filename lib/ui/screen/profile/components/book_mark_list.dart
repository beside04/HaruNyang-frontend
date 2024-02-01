import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:intl/intl.dart';

class BookMarkList extends StatelessWidget {
  const BookMarkList({
    super.key,
    required this.date,
    required this.isBookMark,
    required this.title,
    required this.name,
    required this.onTap,
  });

  final DateTime date;
  final bool isBookMark;
  final String title;
  final String name;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 20, right: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface_01,
          borderRadius: BorderRadius.all(
            Radius.circular(16.w),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: kPrimaryPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          DateFormat('yyyy.MM.dd').format(date),
                          style: kSubtitle1Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                        )
                      ],
                    ),
                    isBookMark
                        ? GestureDetector(
                            onTap: onTap,
                            child: SvgPicture.asset(
                              "lib/config/assets/images/diary/write_diary/bookmark_check.svg",
                              color: Theme.of(context).colorScheme.primaryColor,
                            ),
                          )
                        : GestureDetector(
                            onTap: onTap,
                            child: SvgPicture.asset(
                              "lib/config/assets/images/diary/write_diary/bookmark.svg",
                              color: Theme.of(context).colorScheme.primaryColor,
                            ),
                          ),
                  ],
                ),
                SizedBox(
                  height: 8.h,
                ),
                Text(
                  title,
                  style: kBody1Style.copyWith(color: Theme.of(context).colorScheme.textCaption),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    name == "harunyang" ? "하루냥" : name,
                    style: kBody2Style.copyWith(color: Theme.of(context).colorScheme.textLowEmphasis),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
