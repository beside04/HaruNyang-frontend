import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({
    super.key,
    required this.icon,
    required this.title,
    required this.onPressed,
  });

  final Widget icon;
  final String title;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kWhiteColor,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          color: Colors.transparent,
          child: Padding(
            padding: kPrimaryPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(title, style: kSubtitle2BlackStyle), icon],
            ),
          ),
        ),
      ),
    );
  }
}
