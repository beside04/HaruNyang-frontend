import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/presentation/components/age_text_field.dart';
import 'package:frontend/presentation/components/bottom_button.dart';
import 'package:frontend/presentation/on_boarding/components/on_boarding_stepper.dart';
import 'package:frontend/presentation/on_boarding/on_boarding_age/on_boarding_age_viewmodel.dart';
import 'package:frontend/presentation/on_boarding/on_boarding_job/on_boarding_job_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class OnBoardingAgeScreen extends GetView<OnBoardingAgeViewModel> {
  final String nickname;

  OnBoardingAgeScreen({
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
                    const OnBoardingStepper(
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
                            "몇 살이에요?",
                            style: Theme.of(context).textTheme.headline2,
                          ),
                          SizedBox(
                            height: 40.h,
                          ),
                          AgeTextField(
                            textEditingController:
                                controller.ageEditingController,
                            onTap: () {
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
                            suffixIcon: Obx(
                              () => controller.ageValue.value.isEmpty
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
                                          .ageEditingController
                                          .clear(),
                                    ),
                            ),
                          ),
                          SizedBox(
                            height: 158.h,
                          ),
                          Center(
                            child: SvgPicture.asset(
                              "lib/config/assets/images/character/weather2.svg",
                              width: 300.w,
                              height: 300.h,
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
                  onTap: controller.ageValue.value.isEmpty
                      ? null
                      : () {
                          var key = _fbKey.currentState!;
                          if (key.saveAndValidate()) {
                            FocusScope.of(context).unfocus();
                            Get.to(
                              () => OnBoardingJobScreen(
                                nickname: nickname,
                                birth: controller.ageValue.value,
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
