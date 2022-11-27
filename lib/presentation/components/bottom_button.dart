import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';

class BottomButton extends StatelessWidget {
  const BottomButton({
    super.key,
    required this.title,
    required this.onTap,
  });

  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: EdgeInsets.only(
          left: 16.w,
          bottom: 42.h,
          right: 16.w,
        ),
        child: SizedBox(
          width: 343.w,
          height: 48.h,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: onTap,
            child: Text(
              title,
              style: kSubtitle2WhiteStyle,
            ),
          ),
        ),
      ),
    );
  }
}
