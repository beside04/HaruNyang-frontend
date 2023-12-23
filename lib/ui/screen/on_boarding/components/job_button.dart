import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';

class JobButton extends StatelessWidget {
  final String job;
  final String icon;
  final bool selected;
  final VoidCallback onPressed;

  const JobButton({
    super.key,
    required this.job,
    required this.icon,
    required this.selected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            width: selected ? 96.w : 94.w,
            height: 96.h,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface_01,
              shape: BoxShape.circle,
              border: Border.all(
                width: selected ? 2.w : 0.5.w,
                color: selected
                    ? kOrange300Color
                    : Theme.of(context).colorScheme.outlineDefault,
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: SvgPicture.asset(
                    icon,
                    height: 52.h,
                    width: 52.w,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          Text(
            job,
            style: kSubtitle1Style.copyWith(
                color: Theme.of(context).colorScheme.textSubtitle),
          )
        ],
      ),
    );
  }
}