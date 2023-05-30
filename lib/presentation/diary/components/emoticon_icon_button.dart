import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';

class EmoticonIconButton extends StatelessWidget {
  const EmoticonIconButton({
    super.key,
    required this.icon,
    required this.name,
    required this.selected,
    required this.onPressed,
  });

  final String icon;
  final String name;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0.w),
      child: GestureDetector(
        onTap: onPressed,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Container(
                  padding:
                      selected ? EdgeInsets.all(8.5.w) : EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: selected ? 2.w : 0.5.w,
                      color: selected
                          ? kOrange300Color
                          : Theme.of(context).colorScheme.outlineChip,
                    ),
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.surfaceModal,
                  ),
                  child: Image.asset(
                    icon,
                    width: 40.w,
                    height: 40.h,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                name,
                style: kSubtitle1Style.copyWith(
                    color: Theme.of(context).colorScheme.textCaption),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
