import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';

class OnBoardingStepper extends StatelessWidget {
  const OnBoardingStepper({
    super.key,
    required this.pointNumber,
  });

  final int pointNumber;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Container(
            height: 4.h,
            decoration: BoxDecoration(
              color: pointNumber >= 1 ? kOrange300Color : kGrayColor200,
            ),
          ),
        ),
        Flexible(
          child: Container(
            height: 4.h,
            decoration: BoxDecoration(
              color: pointNumber >= 2 ? kOrange300Color : kGrayColor200,
            ),
          ),
        ),
        Flexible(
          child: Container(
            height: 4.h,
            decoration: BoxDecoration(
              color: pointNumber >= 3 ? kOrange300Color : kGrayColor200,
            ),
          ),
        ),
        Flexible(
          child: Container(
            height: 4.h,
            decoration: BoxDecoration(
              color: pointNumber >= 4 ? kOrange300Color : kGrayColor200,
            ),
          ),
        ),
      ],
    );
  }
}
