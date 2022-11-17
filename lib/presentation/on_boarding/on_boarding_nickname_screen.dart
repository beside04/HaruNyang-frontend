import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/presentation/home/home_screen.dart';
import 'package:frontend/presentation/on_boarding/components/BlackPoints.dart';
import 'package:frontend/presentation/on_boarding/on_boarding_nickname_viewmodel.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class OnBoardingNicknameScreen extends GetView<OnBoardingNicknameViewModel> {
  OnBoardingNicknameScreen({Key? key}) : super(key: key);
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingNicknameViewModel());

    return Scaffold(
      body: FormBuilder(
        key: _fbKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(left: 16.0.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 93.h,
                    ),
                    const BlackPoints(
                      blackNumber: 1,
                    ),
                    SizedBox(
                      height: 7.h,
                    ),
                    Text(
                      "저는 댕청봇이에요",
                      style: kHeader1BlackStyle,
                    ),
                    Text(
                      "제게 별명을 알려주세요!",
                      style: kHeader1BlackStyle,
                    ),
                    SizedBox(
                      height: 22.h,
                    ),
                    SizedBox(
                      width: 327.w,
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0.w),
                        child: FormBuilderTextField(
                          name: 'name',
                          style: kSubtitle4BlackStyle,
                          controller: controller.nicknameEditingController,
                          keyboardType: TextInputType.text,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            helperText: "",
                            counterText: "",
                            hintText: '예시: 덩아',
                            hintStyle: kSubtitle3Gray300Style,
                            contentPadding: const EdgeInsets.only(
                              left: 19,
                              top: 16,
                              bottom: 16,
                              right: 51,
                            ),
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
                              RegExp regex = RegExp(r'([^가-힣a-z\x20])');
                              if (regex.hasMatch(value!)) {
                                return '허용되지 않는 닉네임 입니다.';
                              } else {
                                return null;
                              }
                            },
                          ]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Obx(
              () => Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 28.w,
                    bottom: 37.h,
                    right: 31.w,
                  ),
                  child: SizedBox(
                    width: 331.w,
                    height: 48.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kBlackColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: controller.nicknameValue.value.isEmpty
                          ? null
                          : () {
                              var key = _fbKey.currentState!;
                              if (key.saveAndValidate()) {
                                FocusScope.of(context).unfocus();
                              }
                            },
                      child: Text(
                        "다음",
                        style: kSubtitle2WhiteStyle,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
