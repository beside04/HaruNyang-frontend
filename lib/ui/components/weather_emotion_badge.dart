import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WeatherEmotionBadge extends StatelessWidget {
  const WeatherEmotionBadge({
    super.key,
    required this.weatherIcon,
    required this.emoticon,
    required this.color,
  });

  final String weatherIcon;
  final String emoticon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
          child: Image.asset(
            weatherIcon,
            width: 20.w,
            height: 20.h,
          ),
        ),
        SizedBox(
          width: 7.w,
        ),
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
          child: Image.asset(
            emoticon,
            width: 20.w,
            height: 20.h,
          ),
        ),
      ],
    );
  }
}
