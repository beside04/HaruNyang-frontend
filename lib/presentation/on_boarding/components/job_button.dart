import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';

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
            width: 96.w,
            height: 96.h,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              shape: BoxShape.circle,
              border: Border.all(
                width: selected ? 2 : 0.5,
                color: selected ? kPrimaryColor : kGrayColor100,
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
            style: kSubtitle1BlackStyle,
          )
        ],
      ),
    );
  }
}
