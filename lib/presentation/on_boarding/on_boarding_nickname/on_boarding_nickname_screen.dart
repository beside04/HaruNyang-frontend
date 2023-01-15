import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/core/utils/utils.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/presentation/components/bottom_button.dart';
import 'package:frontend/presentation/components/nickname_text_field.dart';
import 'package:frontend/presentation/on_boarding/components/on_boarding_stepper.dart';
import 'package:frontend/presentation/on_boarding/on_boarding_age/on_boarding_age_screen.dart';
import 'package:frontend/presentation/on_boarding/on_boarding_nickname/on_boarding_nickname_viewmodel.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

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
                  child: ListView(
                    children: [
                      const OnBoardingStepper(
                        pointNumber: 1,
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
                              "안녕하세요, 저는 하루냥이에요",
                              style: kHeader2Style.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.textTitle),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Text(
                              "이름이 뭐에요?",
                              style: kHeader2Style.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.textTitle),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            NicknameTextField(
                              textEditingController:
                                  controller.nicknameEditingController,
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
                            Obx(
                              () => controller.isOnKeyboard.value
                                  ? Container()
                                  : SizedBox(
                                      height: 126.h,
                                    ),
                            ),
                            Center(
                              child: SvgPicture.asset(
                                "lib/config/assets/images/character/onboarding1.svg",
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
                    onTap: controller.nicknameValue.value.isEmpty
                        ? null
                        : () {
                            var key = _fbKey.currentState!;
                            if (key.saveAndValidate()) {
                              FocusScope.of(context).unfocus();

                              Get.to(
                                () => OnBoardingAgeScreen(
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
