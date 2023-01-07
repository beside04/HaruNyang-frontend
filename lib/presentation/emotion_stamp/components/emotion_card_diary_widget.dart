import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/domain/model/diary/diary_data.dart';
import 'package:frontend/presentation/components/weather_emotion_badge_component.dart';
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
        color: Theme.of(context).colorScheme.darkTheme_50_850,
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
                  style: Theme.of(context).textTheme.headline5,
                ),
                WeatherEmotionBadgeComponent(
                  emoticon: diaryData.emotion.emoticon,
                  emoticonIndex: diaryData.emoticonIndex,
                  weatherIcon:
                      "lib/config/assets/images/diary/weather/${diaryData.weather}.svg",
                  color: Theme.of(context).colorScheme.darkTheme_00_700,
                )
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
              style: Theme.of(context).textTheme.bodyText1,
            )
          ],
        ),
      ),
    );
  }
}
