import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';

class BlackPoints extends StatelessWidget {
  const BlackPoints({
    super.key,
    required this.blackNumber,
  });

  final int blackNumber;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12.w,
          height: 12.h,
          decoration: BoxDecoration(
            color: blackNumber == 1 ? kBlackColor : kGrayColor200,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(
          width: 11.w,
        ),
        Container(
          width: 12.w,
          height: 12.h,
          decoration: BoxDecoration(
            color: blackNumber == 2 ? kBlackColor : kGrayColor200,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(
          width: 11.w,
        ),
        Container(
          width: 12.w,
          height: 12.h,
          decoration: BoxDecoration(
            color: blackNumber == 3 ? kBlackColor : kGrayColor200,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}
