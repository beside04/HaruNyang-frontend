import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';

void toast({
  required BuildContext context,
  required String text,
  required bool isCheckIcon,
}) {
  final fToast = FToast();
  fToast.init(context);
  Widget toast = Container(
    width: 335.w,
    height: 64.h,
    padding: kPrimaryPadding,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      color: kBlackColor,
    ),
    child: Row(
      children: [
        isCheckIcon
            ? SvgPicture.asset(
                "lib/config/assets/images/profile/check.svg",
              )
            : SvgPicture.asset(
                "lib/config/assets/images/profile/warning.svg",
              ),
        SizedBox(
          width: 14.w,
        ),
        Text(
          text,
          style: kSubtitle1Style.copyWith(color: kWhiteColor),
        ),
      ],
    ),
  );

  fToast.showToast(
      child: toast,
      toastDuration: const Duration(milliseconds: 2000),
      positionedToastBuilder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              bottom: 60.h,
              child: child,
            ),
          ],
        );
      });
}
