import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          borderRadius: BorderRadius.circular(8),
          color: kKakaoPrimaryColor,
        ),
        width: 360.w,
        height: 56.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 95.0.w,
              ),
              child: SizedBox(
                width: 27.w,
                height: 27.h,
                child: Image.asset(
                  'lib/config/assets/images/login/kakao_logo.png',
                ),
              ),
            ),
            SizedBox(
              width: 7.w,
            ),
            Text(
              "카카오톡으로 로그인",
              style: kSubtitle1BlackStyle,
            ),
          ],
        ),
      ),
    );
  }
}
