import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/presentation/components/bottom_button.dart';
import 'package:frontend/presentation/on_boarding/components/black_points.dart';
import 'package:frontend/presentation/on_boarding/on_boarding_birth/on_boarding_birth_viewmodel.dart';
import 'package:frontend/presentation/on_boarding/on_boarding_job/on_boarding_job_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class OnBoardingBirthScreen extends GetView<OnBoardingBirthViewModel> {
  final String nickname;

  OnBoardingBirthScreen({
    Key? key,
    required this.nickname,
  }) : super(key: key);
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    getOnBoardingBirthBinding();

    return Scaffold(
      body: SafeArea(
        child: FormBuilder(
          key: _fbKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Stack(
            children: [
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BlackPoints(
                      blackNumber: 2,
                    ),
                    Padding(
                      padding: kPrimarySidePadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 40.h,
                          ),
                          Text(
                            nickname,
                            style: kHeader2BlackStyle,
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          Text(
                            "나이는 어떻게 돼?",
                            style: kHeader2BlackStyle,
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          FormBuilderTextField(
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
                              contentPadding: const EdgeInsets.only(
                                top: 14,
                                right: 14,
                                bottom: 14,
                                left: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              suffixIcon: Obx(
                                () => controller.birthValue.value.isEmpty
                                    ? Visibility(
                                        visible: false,
                                        child: Container(),
                                      )
                                    : GestureDetector(
                                        child: const Icon(
                                          Icons.cancel,
                                          color: kGrayColor200,
                                          size: 20,
                                        ),
                                        onTap: () => controller
                                            .birthEditingController
                                            .clear(),
                                      ),
                              ),
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                errorText: '생년월일을 입력해주세요.',
                              ),
                            ]),
                          ),
                          SizedBox(
                            height: 178.h,
                          ),
                          Center(
                            child: SizedBox(
                              width: 240.w,
                              height: 240.h,
                              child: SvgPicture.asset(
                                "lib/config/assets/images/character/onboarding2.svg",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Obx(
                () => BottomButton(
                  title: '다음',
                  onTap: controller.birthValue.value.isEmpty
                      ? null
                      : () {
                          var key = _fbKey.currentState!;
                          if (key.saveAndValidate()) {
                            FocusScope.of(context).unfocus();

                            Get.to(
                              () => OnBoardingJobScreen(
                                nickname: nickname,
                                birth: controller.birthValue.value,
                              ),
                              transition: Transition.cupertino,
                            );
                          }
                        },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
