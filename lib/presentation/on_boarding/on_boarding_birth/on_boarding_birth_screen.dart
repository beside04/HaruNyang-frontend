import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/presentation/on_boarding/components/black_points.dart';
import 'package:frontend/presentation/on_boarding/on_boarding_birth/on_boarding_birth_viewmodel.dart';
import 'package:frontend/presentation/on_boarding/on_boarding_job/on_boarding_job_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class OnBoardingBirthScreen extends GetView<OnBoardingBirthViewModel> {
  final String socialId;

  OnBoardingBirthScreen({
    Key? key,
    required this.socialId,
  }) : super(key: key);
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    getOnBoardingBirthBinding();

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
                      blackNumber: 2,
                    ),
                    SizedBox(
                      height: 7.h,
                    ),
                    Text(
                      "몇 살이에요?",
                      style: kHeader1BlackStyle,
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                    SizedBox(
                      width: 322.w,
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0.w),
                        child: FormBuilderTextField(
                          controller: controller.birthEditingController,
                          style: kSubtitle4BlackStyle,
                          onTap: () async {
                            DatePicker.showDatePicker(
                              context,
                              showTitleActions: true,
                              minTime: DateTime(1930, 1, 1),
                              maxTime: DateTime(2005, 12, 30),
                              onConfirm: (date) {
                                controller.getBirthDateFormat(date);
                              },
                              currentTime: DateTime(1995, 12, 30),
                              locale: LocaleType.ko,
                            );
                          },
                          readOnly: true,
                          name: 'birth',
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            helperText: "",
                            counterText: "",
                            hintText: 'YYYY/MM/DD 입력',
                            hintStyle: kSubtitle3Gray300Style,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 19,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                              errorText: '생년월일을 입력해주세요.',
                            ),
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
                      onPressed: controller.birthValue.value.isEmpty
                          ? null
                          : () {
                              var key = _fbKey.currentState!;
                              if (key.saveAndValidate()) {
                                FocusScope.of(context).unfocus();

                                Get.to(
                                  () => OnBoardingJobScreen(
                                    socialId: socialId,
                                  ),
                                  transition: Transition.cupertino,
                                );
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
