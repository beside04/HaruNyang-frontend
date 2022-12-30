import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';

class OnBoardingStepper extends StatelessWidget {
  const OnBoardingStepper({
    super.key,
    required this.blackNumber,
  });

  final int blackNumber;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Container(
            height: 4.h,
            decoration: BoxDecoration(
              color: blackNumber >= 1 ? kPrimary2Color : kGrayColor200,
            ),
          ),
        ),
        Flexible(
          child: Container(
            height: 4.h,
            decoration: BoxDecoration(
              color: blackNumber >= 2 ? kPrimary2Color : kGrayColor200,
            ),
          ),
        ),
        Flexible(
          child: Container(
            height: 4.h,
            decoration: BoxDecoration(
              color: blackNumber >= 3 ? kPrimary2Color : kGrayColor200,
            ),
          ),
        ),
        Flexible(
          child: Container(
            height: 4.h,
            decoration: BoxDecoration(
              color: blackNumber >= 4 ? kPrimary2Color : kGrayColor200,
            ),
          ),
        ),
      ],
    );
  }
}
