import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
        : SvgPicture.asset(
            'lib/config/assets/images/check/unselected_radio.svg',
            width: 24,
            height: 24,
          );
  }
}
