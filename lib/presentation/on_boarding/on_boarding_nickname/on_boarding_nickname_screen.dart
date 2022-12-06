import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/core/utils/utils.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/presentation/components/bottom_button.dart';
import 'package:frontend/presentation/on_boarding/components/black_points.dart';
import 'package:frontend/presentation/on_boarding/on_boarding_birth/on_boarding_birth_screen.dart';
import 'package:frontend/presentation/on_boarding/on_boarding_nickname/on_boarding_nickname_viewmodel.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

class OnBoardingNicknameScreen extends GetView<OnBoardingNicknameViewModel> {
  const OnBoardingNicknameScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getOnBoardingNickNameBinding();

    return WillPopScope(
      onWillPop: () async {
        bool backResult = GlobalUtils.onBackPressed();
        return await Future.value(backResult);
      },
      child: Scaffold(
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
                        blackNumber: 1,
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
                              "안녕 나는 하루냥이야",
                              style: kHeader2BlackStyle,
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Text(
                              "널 뭐라고 부르면 좋을까?",
                              style: kHeader2BlackStyle,
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            FormBuilderTextField(
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
                                  top: 14,
                                  right: 14,
                                  bottom: 14,
                                  left: 16,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                suffixIcon: Obx(
                                  () => controller.nicknameValue.value.isEmpty
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
                                              .nicknameEditingController
                                              .clear(),
                                        ),
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => BottomButton(
                    title: '다음',
                    onTap: controller.nicknameValue.value.isEmpty
                        ? null
                        : () {
                            var key = _fbKey.currentState!;
                            if (key.saveAndValidate()) {
                              FocusScope.of(context).unfocus();

                              Get.to(
                                () => OnBoardingBirthScreen(
                                  nickname: controller.nicknameValue.value,
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
      ),
    );
  }
}
