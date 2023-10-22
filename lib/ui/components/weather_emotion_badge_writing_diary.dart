import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';

class WeatherEmotionBadgeWritingDiary extends StatelessWidget {
  const WeatherEmotionBadgeWritingDiary({
    super.key,
    required this.weatherIcon,
    required this.emoticon,
    required this.weatherIconDesc,
    required this.emoticonDesc,
    required this.color,
  });

  final String weatherIcon;
  final String emoticon;
  final String weatherIconDesc;
  final String emoticonDesc;

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding:
              EdgeInsets.only(left: 8.w, right: 10.w, top: 6.w, bottom: 6.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: color,
          ),
          child: Row(
            children: [
              Image.asset(
                weatherIcon,
                width: 20.w,
                height: 20.h,
              ),
              SizedBox(
                width: 4.w,
              ),
              Text(
                weatherIconDesc,
                style: kBody2Style.copyWith(
                    color: Theme.of(context).colorScheme.textCaption),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 8.w,
        ),
        Container(
          padding:
              EdgeInsets.only(left: 8.w, right: 10.w, top: 6.w, bottom: 6.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: color,
          ),
          child: Row(
            children: [
              Image.asset(
                emoticon,
                width: 20.w,
                height: 20.h,
              ),
              SizedBox(
                width: 4.w,
              ),
              Text(emoticonDesc,
                  style: kBody2Style.copyWith(
                      color: Theme.of(context).colorScheme.textCaption)),
            ],
          ),
        ),
      ],
    );
  }
}
