import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/text_data.dart';

class EmotionStampDetailScreen extends StatelessWidget {
  final String? icon;
  final String? title;

  const EmotionStampDetailScreen({
    Key? key,
    required this.icon,
    required this.title,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              title == null
                  ? Column(
                      children: [
                        SizedBox(
                          height: 50.h,
                        ),
                        Text(
                          "일기 작성",
                          style: kSubtitle2BlackStyle,
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        SizedBox(
                          height: 50.h,
                        ),
                        Text(
                          "$icon",
                          style: TextStyle(fontSize: 40.sp),
                        ),
                        Text(
                          "$title",
                          style: kSubtitle2BlackStyle,
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
