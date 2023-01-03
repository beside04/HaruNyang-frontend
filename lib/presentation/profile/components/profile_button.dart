import 'package:flutter/material.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({
    super.key,
    required this.icon,
    required this.title,
    required this.onPressed,
    this.isLightMode = true,
  });

  final Widget icon;
  final String title;
  final VoidCallback? onPressed;
  final bool isLightMode;

  @override
  Widget build(BuildContext context) {
    return Material(
      // color: isLightMode ? kWhiteColor : kBackGroundDarkColor,
      color: Theme.of(context).colorScheme.primary,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          // color: Colors.transparent,
          child: Padding(
            padding: kPrimaryPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headline5,
                  //style: isLightMode ? kHeader5BlackStyle : kHeader5WhiteStyle,
                ),
                icon
              ],
            ),
          ),
        ),
      ),
    );
  }
}
