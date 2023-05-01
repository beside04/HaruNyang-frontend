import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class WeatherEmotionBadgeWritingDiary extends StatelessWidget {
  const WeatherEmotionBadgeWritingDiary({
    super.key,
    required this.weatherIcon,
    required this.emoticon,
    required this.emoticonIndex,
    required this.color,
  });

  final String weatherIcon;
  final String emoticon;
  final int emoticonIndex;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
          child: SvgPicture.network(
            weatherIcon,
            width: 24.w,
            height: 24.h,
          ),
        ),
        SizedBox(
          width: 8.w,
        ),
        Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
          child: Row(
            children: [
              SvgPicture.network(
                emoticon,
                width: 24.w,
                height: 24.h,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
