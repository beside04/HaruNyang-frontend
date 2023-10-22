import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';

class DialogComponent extends StatelessWidget {
  const DialogComponent({
    super.key,
    required this.title,
    this.content,
    required this.actionContent,
    this.titlePadding = const EdgeInsets.only(
      left: 24.0,
      top: 24.0,
      right: 24.0,
      bottom: 0,
    ),
  });

  final String title;
  final Widget? content;
  final List<Widget> actionContent;
  final EdgeInsetsGeometry titlePadding;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: titlePadding,
      backgroundColor: Theme.of(context).colorScheme.backgroundModal,
      insetPadding: EdgeInsets.symmetric(
        horizontal: 20.w,
      ),
      contentPadding: EdgeInsets.only(
        top: 4.h,
        bottom: 10.h,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      title: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Text(
            title,
            style: kHeader3Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
          ),
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
