import 'package:flutter/material.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';

class BookMarkEmoticonIconButton extends StatelessWidget {
  const BookMarkEmoticonIconButton({
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
    print(selected);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 10),
              shadowColor: Colors.transparent,
              disabledBackgroundColor: Theme.of(context).colorScheme.disabledColor,
              backgroundColor: selected ? kBlackColor : Theme.of(context).colorScheme.surface_01,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: onPressed,
            child: Row(
              children: [
                Image.asset(
                  icon,
                  width: 20,
                  height: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  name,
                  style: kBody2Style.copyWith(color: Theme.of(context).colorScheme.textCaption),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
