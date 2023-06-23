import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/domain/model/diary/diary_data.dart';
import 'package:frontend/presentation/components/weather_emotion_badge.dart';
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
        color: Theme.of(context).colorScheme.surface_01,
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
                  DateFormat('M월 d일 E요일', 'ko_KR')
                      .format(DateTime.parse(diaryData.targetDate)),
                  style: kHeader5Style.copyWith(
                      color: Theme.of(context).colorScheme.textTitle),
                ),
                WeatherEmotionBadge(
                  emoticon: getEmoticonImage(diaryData.feeling),
                  weatherIcon: getWeatherImage(diaryData.weather),
                  color: Theme.of(context).colorScheme.surfaceModal,
                )
              ],
            ),
            SizedBox(
              height: 12.h,
            ),
            // diaryData.images[0] == ""
            //     ? Container()
            //     : Column(
            //         children: [
            //           Center(
            //             child: Image.network(
            //               diaryData.images[0],
            //               width: double.infinity,
            //               fit: BoxFit.cover,
            //             ),
            //           ),
            //           SizedBox(
            //             height: 12.h,
            //           ),
            //         ],
            //       ),
            Text(
              diaryData.diaryContent,
              style: kBody2Style.copyWith(
                  color: Theme.of(context).colorScheme.textBody),
            )
          ],
        ),
      ),
    );
  }
}
