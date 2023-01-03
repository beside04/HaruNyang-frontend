import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/domain/model/diary/diary_data.dart';
import 'package:frontend/res/constants.dart';
import 'package:intl/intl.dart';

class EmotionCardDiaryWidget extends StatelessWidget {
  const EmotionCardDiaryWidget({
    Key? key,
    required this.diaryData,
  }) : super(key: key);

  final DiaryData diaryData;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kGrayColor50,
        borderRadius: BorderRadius.circular(20.0.w),
      ),
      child: Padding(
        padding: kPrimaryPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat.MMMEd("ko_KR")
                      .format(DateTime.parse(diaryData.writtenAt)),
                  style: kSubtitle2BlackStyle,
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: kWhiteColor,
                      ),
                      child: SvgPicture.asset(
                        "lib/config/assets/images/diary/weather/sunny.svg",
                        width: 16.w,
                        height: 16.h,
                      ),
                    ),
                    SizedBox(
                      width: 7.w,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                      decoration: BoxDecoration(
                        color: kWhiteColor,
                        borderRadius: BorderRadius.circular(100.0.w),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.network(
                            diaryData.emotion.emoticon,
                            width: 16.w,
                            height: 16.h,
                          ),
                          SizedBox(
                            width: 6.w,
                          ),
                          getEmotionTextWidget(
                            diaryData.emoticonIndex,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 12.h,
            ),
            diaryData.images[0] == ""
                ? Container()
                : Column(
                    children: [
                      Center(
                        child: Image.network(
                          diaryData.images[0],
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                    ],
                  ),
            Text(
              diaryData.diaryContent,
              style: kBody1BlackStyle,
            )
          ],
        ),
      ),
    );
  }
}
