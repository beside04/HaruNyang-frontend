import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/config/theme/theme_data.dart';

class RoundRadioCheckbox extends StatefulWidget {
  final bool isSelected;

  const RoundRadioCheckbox({super.key, required this.isSelected});

  @override
  State<RoundRadioCheckbox> createState() => _RoundRadioCheckboxState();
}

class _RoundRadioCheckboxState extends State<RoundRadioCheckbox> {
  @override
  Widget build(BuildContext context) {
    return widget.isSelected
        ? SvgPicture.asset(
            'lib/config/assets/images/check/radio.svg',
            width: 24,
            height: 24,
          )
        : Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border.all(
                color: Theme.of(context).colorScheme.textSubtitle,
                width: 1,
              ),
            ),
          );
  }
}
