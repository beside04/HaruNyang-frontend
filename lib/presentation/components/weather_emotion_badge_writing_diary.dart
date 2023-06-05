import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
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
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Theme.of(context).colorScheme.surface_01,
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                weatherIcon,
                width: 24.w,
                height: 24.h,
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                weatherIconDesc,
                style: kBody2Style.copyWith(
                    color: Theme.of(context).colorScheme.textTitle),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 8.w,
        ),
        Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Theme.of(context).colorScheme.surface_01,
          ),
          child: Row(
            children: [
              Image.asset(
                emoticon,
                width: 24.w,
                height: 24.h,
              ),
              SizedBox(
                width: 4,
              ),
              Text(emoticonDesc,
                  style: kBody2Style.copyWith(
                      color: Theme.of(context).colorScheme.textTitle)),
            ],
          ),
        ),
      ],
    );
  }
}
