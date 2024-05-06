import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/config/constants.dart';
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
    required this.feeling,
  });

  final DateTime date;
  final bool isBookMark;
  final String title;
  final String name;
  final VoidCallback? onTap;
  final String feeling;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 16, right: 20),
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
            padding: const EdgeInsets.only(left: 16, right: 20, bottom: 20, top: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  getEmoticonImage(feeling),
                  width: 40,
                  height: 40,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    name == "harunyang" ? "하루냥" : name,
                                    style: kSubtitle1Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                                  ),
                                ),
                                Text(
                                  DateFormat('yyyy.MM.dd').format(date),
                                  style: kBody2Style.copyWith(color: Theme.of(context).colorScheme.textSubtitle),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            title,
                            style: kBody1Style.copyWith(color: Theme.of(context).colorScheme.textCaption),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "일기 보기",
                              style: kBody2Style.copyWith(color: Theme.of(context).colorScheme.textLowEmphasis),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 3.0, left: 8),
                              child: SvgPicture.asset(
                                "lib/config/assets/images/profile/navigate_next.svg",
                                color: Theme.of(context).colorScheme.iconSubColor,
                                width: 12,
                                height: 12,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
