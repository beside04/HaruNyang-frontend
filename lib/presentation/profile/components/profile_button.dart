import 'package:flutter/material.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';

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
    return InkWell(
      onTap: onPressed,
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
    );
  }
}
