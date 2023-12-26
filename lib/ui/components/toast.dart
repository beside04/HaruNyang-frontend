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
  int milliseconds = 2000,
}) {
  final fToast = FToast();
  fToast.init(context);
  fToast.removeCustomToast();

  Widget toast = Container(
    width: 335.w,
    padding: kPrimaryPadding,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      color: kBlackColor,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
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
          style: kBody2Style.copyWith(color: kWhiteColor),
        ),
      ],
    ),
  );

  double calculateValue(double x) {
    double m = -0.14545454545454545;
    double b = 197.0181818181818;
    return m * x + b;
  }

  fToast.showToast(
    child: toast,
    toastDuration: Duration(milliseconds: milliseconds),
    positionedToastBuilder: (context, child) {
      final deviceSize = MediaQuery.of(context).size.height;
      return Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: calculateValue(deviceSize),
            child: Container(
              child: child,
            ),
          ),
        ],
      );
    },
  );
}
