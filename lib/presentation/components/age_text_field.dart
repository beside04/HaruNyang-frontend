import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';

class AgeTextField extends StatelessWidget {
  const AgeTextField({
    super.key,
    required this.textEditingController,
    required this.onTap,
    required this.suffixIcon,
    required this.isSettingAge,
    required this.hintText,
  });

  final TextEditingController textEditingController;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final bool isSettingAge;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      controller: textEditingController,
      style: kSubtitle1Style.copyWith(
          color: Theme.of(context).colorScheme.textTitle),
      onTap: onTap,
      readOnly: true,
      name: 'age',
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        helperText: isSettingAge ? null : "필수 정보가 아니라 다음에 작성해도 좋아요!",
        helperStyle: kBody3Style.copyWith(
            color: Theme.of(context).colorScheme.textTitle),
        counterText: "",
        hintText: hintText == "2000-01-01" ? "YYYY-MM-DD 입력" : hintText,
        hintStyle: kSubtitle1Style.copyWith(
            color: Theme.of(context).colorScheme.placeHolder),
        contentPadding: const EdgeInsets.only(
          top: 14,
          bottom: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
