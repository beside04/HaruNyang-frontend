import 'package:flutter/material.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';

class PasswordTextDisplay extends StatelessWidget {
  final String passwordKeyword;
  final String passwordText;
  final bool? isHintVisible;
  final String? hint;

  const PasswordTextDisplay({
    super.key,
    required this.passwordKeyword,
    required this.passwordText,
    this.isHintVisible,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            passwordText,
            style: kHeader3Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < 4; i++)
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Image.asset(
                        "lib/config/assets/images/password/password_key.png",
                        width: 40,
                        height: 40,
                        color: passwordKeyword.length > i ? Theme.of(context).colorScheme.primaryColor : Theme.of(context).colorScheme.surface_02,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Visibility(
              visible: isHintVisible ?? false,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface_02,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(4.0),
                  ),
                ),
                child: Text(
                  "$hint",
                  style: kBody3Style.copyWith(color: Theme.of(context).colorScheme.textCaption),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
