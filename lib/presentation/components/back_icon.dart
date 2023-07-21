import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/main_view_model.dart';
import 'package:get/get.dart';

class BackIcon extends StatelessWidget {
  const BackIcon({
    super.key,
    required this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: SvgPicture.asset(
        "lib/config/assets/images/home/dark_mode/arrow.svg",
        color: Theme.of(context).colorScheme.iconColor,
      ),
    );
  }
}
