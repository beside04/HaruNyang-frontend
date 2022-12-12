import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DialogButton extends StatelessWidget {
  const DialogButton({
    super.key,
    required this.title,
    required this.onTap,
    required this.backgroundColor,
    required this.textStyle,
  });

  final String title;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 52.h,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60),
            ),
          ),
          child: Text(
            title,
            style: textStyle,
          ),
        ),
      ),
    );
  }
}
