import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';

class NicknameTextField extends StatelessWidget {
  const NicknameTextField({
    super.key,
    required this.textEditingController,
    required this.suffixIcon,
  });

  final TextEditingController textEditingController;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: 'name',
      style: kSubtitle1Style.copyWith(
          color: Theme.of(context).colorScheme.textTitle),
      controller: textEditingController,
      keyboardType: TextInputType.text,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        helperText: "",
        counterText: "",
        hintText: '이름',
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
        FormBuilderValidators.minLength(
          2,
          errorText: '2글자 이상 입력해 주세요.',
        ),
        FormBuilderValidators.maxLength(
          12,
          errorText: '12글자 이내로 입력해 주세요.',
        ),
        (value) {
          if (value!.contains(' ')) {
            return '띄어쓰기는 사용 할 수 없어요.';
          }

          RegExp regex = RegExp(r'([^가-힣a-z\x20])');
          if (regex.hasMatch(value)) {
            return '사용할 수 없는 닉네임이에요.';
          } else {
            return null;
          }
        },
      ]),
    );
  }
}
