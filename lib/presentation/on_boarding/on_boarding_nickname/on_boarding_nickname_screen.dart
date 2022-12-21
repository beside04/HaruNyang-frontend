import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/core/utils/utils.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/presentation/components/bottom_button.dart';
import 'package:frontend/presentation/components/nickname_text_field.dart';
import 'package:frontend/presentation/on_boarding/components/black_points.dart';
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
                                      height: 178.h,
                                    ),
                            ),
                            Center(
                              child: SizedBox(
                                width: 240.w,
                                height: 240.h,
                                child: SvgPicture.asset(
                                  "lib/config/assets/images/character/onboarding1.svg",
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
