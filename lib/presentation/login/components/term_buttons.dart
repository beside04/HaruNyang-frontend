import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';

class TermButtons extends StatelessWidget {
  const TermButtons({
    super.key,
    required this.title,
    required this.onTap,
    required this.isAgree,
  });

  final String title;
  final VoidCallback onTap;
  final bool isAgree;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isAgree ? kBlackColor : kGrayColor300,
        ),
        width: 360.w,
        height: 54.h,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20.0.w, top: 13.0.h),
              child: Icon(
                color: kWhiteColor,
                Icons.done,
                size: 24.w,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 65.0.w,
                top: 15.h,
              ),
              child: Text(
                title,
                style: kSubtitle1WhiteStyle,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 309.0.w,
                top: 15.0.h,
                right: 27.0.w,
              ),
              child: Icon(
                color: kWhiteColor,
                Icons.arrow_forward_ios,
                size: 24.w,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
