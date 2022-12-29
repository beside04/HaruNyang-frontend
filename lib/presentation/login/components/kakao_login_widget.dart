import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';

class KakaoLoginWidget extends StatelessWidget {
  const KakaoLoginWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0.w),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60.w),
          color: kKakaoPrimaryColor,
        ),
        width: 360.w,
        height: 56.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'lib/config/assets/images/login/kakao_logo.svg',
              width: 16.w,
              height: 16.h,
            ),
            SizedBox(
              width: 7.w,
            ),
            Text(
              "카카오로 시작하기",
              style: kSubtitle2BlackStyle,
            ),
          ],
        ),
      ),
    );
  }
}
