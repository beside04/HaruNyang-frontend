import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/domain/model/diary/diary_data.dart';
import 'package:frontend/domains/diary/provider/diary_provider.dart';
import 'package:frontend/res/constants.dart';
import 'package:frontend/ui/components/weather_emotion_badge.dart';
import 'package:frontend/ui/screen/diary/diary_detail/diary_detail_screen.dart';
import 'package:frontend/ui/screen/diary/write_diary_screen.dart';
import 'package:intl/intl.dart';

class EmotionCardDiaryWidget extends ConsumerWidget {
  const EmotionCardDiaryWidget({
    Key? key,
    required this.diaryData,
  }) : super(key: key);

  final DiaryData diaryData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        if (diaryData.isAutoSave) {
          final saveDiary = await ref.watch(diaryProvider.notifier).getTempDiary(DateTime.parse(diaryData.targetDate));
          Map<String, dynamic> diaryMap = json.decode(saveDiary!);
          DiaryData saveDiaryData = DiaryData.fromJson(diaryMap);

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WriteDiaryScreen(
                      date: DateTime.parse(diaryData.targetDate),
                      emotion: diaryData.feeling,
                      weather: diaryData.weather,
                      diaryData: diaryData,
                      isEditScreen: saveDiaryData.id == null ? false : true,
                      isAutoSave: true,
                    )),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DiaryDetailScreen(
                diaryId: diaryData.id!,
                date: DateTime.parse(diaryData.targetDate),
                diaryData: diaryData,
                isNewDiary: false,
              ),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.backgroundListColor,
          borderRadius: BorderRadius.circular(20.0.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
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
                    DateFormat('M월 d일 E요일', 'ko_KR').format(DateTime.parse(diaryData.targetDate)),
                    style: kHeader5Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                  ),
                  WeatherEmotionBadge(
                    emoticon: diaryData.isAutoSave
                        ? Theme.of(context).colorScheme.brightness == Brightness.dark
                            ? "lib/config/assets/images/diary/emotion/save-dark.png"
                            : "lib/config/assets/images/diary/emotion/save-light.png"
                        : getEmoticonImage(diaryData.feeling),
                    weatherIcon: getWeatherImage(diaryData.weather),
                    color: Theme.of(context).colorScheme.surfaceModal,
                  )
                ],
              ),
              SizedBox(
                height: 12.h,
              ),
              Text(
                diaryData.diaryContent,
                style: kBody2Style.copyWith(color: Theme.of(context).colorScheme.textBody),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
