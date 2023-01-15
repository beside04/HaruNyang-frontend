import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
          borderRadius: BorderRadius.circular(60.w),
          color: kBlackColor,
        ),
        width: 360.w,
        height: 56.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'lib/config/assets/images/login/apple_logo.svg',
              width: 13.w,
              height: 16.h,
            ),
            SizedBox(
              width: 7.w,
            ),
            Text(
              "애플로 시작하기",
              style: kHeader5Style.copyWith(color: kWhiteColor),
            ),
          ],
        ),
      ),
    );
  }
}
