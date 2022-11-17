import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';

class JobButton extends StatelessWidget {
  final String job;
  final bool selected;
  final VoidCallback onPressed;
  const JobButton(
    this.job, {
    super.key,
    required this.selected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170.w,
      height: 48.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          splashFactory: NoSplash.splashFactory,
          backgroundColor: selected ? kBlackColor : kGrayColor50,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onPressed,
        child: Text(
          job,
          style: selected ? kSubtitle3White300Style : kSubtitle3Gray300Style,
        ),
      ),
    );
  }
}
