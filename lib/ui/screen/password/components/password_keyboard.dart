import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/ui/screen/password/components/password_keyboard_key.dart';

class PasswordKeyboard extends StatelessWidget {
  final ValueSetter<dynamic> onNumberPress;
  final ValueSetter<void> onBackspacePress;
  final void Function(dynamic)? bioAuthOnTap;
  final bool? isBioAuth;

  const PasswordKeyboard({
    super.key,
    required this.onNumberPress,
    required this.onBackspacePress,
    this.bioAuthOnTap,
    this.isBioAuth,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.33,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: KeyboardKey(
                    label: 1.toString(),
                    onTap: onNumberPress,
                    value: 1.toString(),
                  ),
                ),
                Expanded(
                  child: KeyboardKey(
                    label: 2.toString(),
                    onTap: onNumberPress,
                    value: 2.toString(),
                  ),
                ),
                Expanded(
                  child: KeyboardKey(
                    label: 3.toString(),
                    onTap: onNumberPress,
                    value: 3.toString(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: KeyboardKey(
                    label: 4.toString(),
                    onTap: onNumberPress,
                    value: 4.toString(),
                  ),
                ),
                Expanded(
                  child: KeyboardKey(
                    label: 5.toString(),
                    onTap: onNumberPress,
                    value: 5.toString(),
                  ),
                ),
                Expanded(
                  child: KeyboardKey(
                    label: 6.toString(),
                    onTap: onNumberPress,
                    value: 6.toString(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: KeyboardKey(
                    label: 7.toString(),
                    onTap: onNumberPress,
                    value: 7.toString(),
                  ),
                ),
                Expanded(
                  child: KeyboardKey(
                    label: 8.toString(),
                    onTap: onNumberPress,
                    value: 8.toString(),
                  ),
                ),
                Expanded(
                  child: KeyboardKey(
                    label: 9.toString(),
                    onTap: onNumberPress,
                    value: 9.toString(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: isBioAuth == false || isBioAuth == null
                      ? const AspectRatio(
                          aspectRatio: 2,
                          child: Center(
                            child: Text(
                              "",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      : KeyboardKey(
                          label: Platform.isAndroid
                              ? const Icon(Icons.fingerprint)
                              : Image.asset(
                                  "lib/config/assets/images/password/password_face_id.png",
                                  color: Theme.of(context).colorScheme.textTitle,
                                  height: 24,
                                  width: 24,
                                ),
                          onTap: bioAuthOnTap!,
                          value: null,
                        ),
                ),
                Expanded(
                  child: KeyboardKey(
                    label: 0.toString(),
                    onTap: onNumberPress,
                    value: 0.toString(),
                  ),
                ),
                Expanded(
                  child: KeyboardKey(
                    label: Image.asset(
                      "lib/config/assets/images/password/password_delete.png",
                      color: Theme.of(context).colorScheme.textTitle,
                      height: 24,
                      width: 24,
                    ),
                    onTap: onBackspacePress,
                    value: null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
