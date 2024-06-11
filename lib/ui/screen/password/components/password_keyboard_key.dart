import 'package:flutter/material.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';

class KeyboardKey extends StatefulWidget {
  final dynamic label;
  final dynamic value;
  final ValueSetter<dynamic> onTap;

  const KeyboardKey({
    super.key,
    required this.label,
    required this.onTap,
    required this.value,
  });

  @override
  // ignore: library_private_types_in_public_api
  _KeyboardKeyState createState() => _KeyboardKeyState();
}

class _KeyboardKeyState extends State<KeyboardKey> {
  renderLabel() {
    if (widget.label is String) {
      return Text(
        widget.label,
        style: kHeader2Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
      );
    } else {
      return widget.label;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        highlightColor: Theme.of(context).colorScheme.surface_02,
        splashColor: Theme.of(context).colorScheme.surface_02,
        onTap: () {
          widget.onTap(widget.value);
        },
        child: AspectRatio(
          aspectRatio: 2,
          child: Center(
            child: renderLabel(),
          ),
        ),
      ),
    );
  }
}
