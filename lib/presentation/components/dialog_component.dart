import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:get/get.dart';

class DialogComponent extends StatelessWidget {
  const DialogComponent({
    super.key,
    required this.title,
    this.content,
    required this.actionContent,
  });

  final String title;
  final Widget? content;
  final List<Widget> actionContent;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: 20.w,
      ),
      contentPadding: EdgeInsets.only(
        top: 10.h,
        bottom: 24.h,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      title: Center(
        child: Text(
          title.tr,
          style: kHeader3BlackStyle,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: Center(child: content),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(
            bottom: 20.0.h,
            left: 20.w,
            right: 20.w,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: actionContent,
          ),
        ),
      ],
    );
  }
}
