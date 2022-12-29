import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/presentation/login/login_terms_information/login_terms_information_viewmodel.dart';
import 'package:get/get.dart';

class TermCheckBox extends GetView<LoginTermsInformationViewModel> {
  const TermCheckBox({
    super.key,
    required this.termTitle,
    required this.onTap,
    required this.termOnTap,
    required this.termValue,
  });

  final Widget termTitle;
  final VoidCallback onTap;
  final VoidCallback termOnTap;
  final bool termValue;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                width: 20.w,
                height: 20.h,
                child: Checkbox(
                  activeColor: kPrimaryColor,
                  value: termValue,
                  onChanged: (value) {
                    if (value != null) onTap;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0.w),
                child: termTitle,
              ),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: termOnTap,
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0.h, top: 8.w, bottom: 8.w),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: kGrayColor400,
                    size: 20.w,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
