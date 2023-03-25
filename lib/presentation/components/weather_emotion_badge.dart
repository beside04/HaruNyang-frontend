import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class WeatherEmotionBadge extends StatelessWidget {
  const WeatherEmotionBadge({
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
            width: 16.w,
            height: 16.h,
          ),
        ),
        SizedBox(
          width: 7.w,
        ),
        Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
          child: SvgPicture.network(
            emoticon,
            width: 16.w,
            height: 16.h,
          ),
        ),
      ],
    );
  }
}
