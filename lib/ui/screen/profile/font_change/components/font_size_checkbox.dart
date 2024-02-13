import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';

class FontSizeCheckBox extends StatefulWidget {
  final String label;
  final bool isSelected;
  final Function onPressed;

  const FontSizeCheckBox({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  State<FontSizeCheckBox> createState() => _FontSizeCheckBoxState();
}

class _FontSizeCheckBoxState extends State<FontSizeCheckBox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onPressed();
      },
      behavior: HitTestBehavior.translucent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              width: 26,
              height: 26,
              child: Center(
                child: widget.isSelected
                    ? SvgPicture.asset(
                        'lib/config/assets/images/check/round_checkbox.svg',
                        width: 24,
                        height: 24,
                      )
                    : SvgPicture.asset(
                        'lib/config/assets/images/check/dot.svg',
                        width: 8,
                        height: 8,
                      ),
              )),
          const SizedBox(height: 20),
          Text(
            widget.label,
            style: kBody3Style.copyWith(
              color: Theme.of(context).colorScheme.textLowEmphasis,
            ),
          ),
        ],
      ),
    );
  }
}
