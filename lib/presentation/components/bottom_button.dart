import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';

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
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(
          left: 16.w,
          bottom: 50.h,
          right: 16.w,
        ),
        child: SizedBox(
          width: 335.w,
          height: 52.h,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              disabledBackgroundColor:
                  Theme.of(context).colorScheme.disabledColor,
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(60),
              ),
            ),
            onPressed: onTap,
            child: Text(
              title,
              style: kHeader5Style.copyWith(color: kWhiteColor),
            ),
          ),
        ),
      ),
    );
  }
}
