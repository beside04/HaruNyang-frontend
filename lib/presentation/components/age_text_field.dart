import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';

class AgeTextField extends StatelessWidget {
  const AgeTextField({
    super.key,
    required this.textEditingController,
    required this.onTap,
    required this.suffixIcon,
  });

  final TextEditingController textEditingController;
  final VoidCallback? onTap;
  final Widget? suffixIcon;

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
        helperText: "",
        counterText: "",
        hintText: 'YYYY-MM-DD 입력',
        hintStyle: kSubtitle1Style.copyWith(
            color: Theme.of(context).colorScheme.placeHolder),
        contentPadding: const EdgeInsets.only(
          top: 14,
          right: 14,
          bottom: 14,
          left: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: suffixIcon,
      ),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(
          errorText: '생년월일을 입력해주세요.',
        ),
      ]),
    );
  }
}
