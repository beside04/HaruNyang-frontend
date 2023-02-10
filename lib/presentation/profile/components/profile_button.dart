import 'package:flutter/material.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/main_view_model.dart';
import 'package:get/get.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({
    super.key,
    required this.icon,
    required this.title,
    required this.onPressed,
    this.padding = const EdgeInsets.all(20),
  });

  final Widget icon;
  final String title;
  final VoidCallback? onPressed;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final mainViewController = Get.find<MainViewModel>();

    return InkWell(
      onTap: onPressed,
      child: Container(
        color: mainViewController.isDarkMode.value
            ? kGrayColor950
            : kBeigeColor100,
        child: Padding(
          padding: padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: kHeader5Style.copyWith(
                    color: Theme.of(context).colorScheme.textTitle),
              ),
              icon
            ],
          ),
        ),
      ),
    );
  }
}
