import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';

import '../../../config/theme/text_data.dart';

class AppleLoginWidget extends StatelessWidget {
  const AppleLoginWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0.w),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: kBlackColor,
        ),
        width: 360.w,
        height: 56.h,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 95.0.w,
                top: 10.h,
              ),
              child: SizedBox(
                width: 51.w,
                height: 35.h,
                child: Image.asset(
                  'lib/config/assets/images/login/apple_logo.png',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 138.0.w,
                top: 18.h,
              ),
              child: Text(
                "애플로 로그인",
                style: kSubtitle1WhiteStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
