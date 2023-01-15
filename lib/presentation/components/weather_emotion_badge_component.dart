import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/res/constants.dart';

class WeatherEmotionBadgeComponent extends StatelessWidget {
  const WeatherEmotionBadgeComponent({
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
          child: SvgPicture.asset(
            weatherIcon,
            width: 16.w,
            height: 16.h,
          ),
        ),
        SizedBox(
          width: 7.w,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(100.0.w),
          ),
          child: Row(
            children: [
              SvgPicture.network(
                emoticon,
                width: 16.w,
                height: 16.h,
              ),
              SizedBox(
                width: 6.w,
              ),
              getEmotionTextWidget(
                emoticonIndex,
                kBody2Style.copyWith(
                    color: Theme.of(context).colorScheme.textCaption),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
