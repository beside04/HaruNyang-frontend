import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/core/utils/utils.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/global_controller/on_boarding/on_boarding_controller.dart';
import 'package:frontend/presentation/components/bottom_button.dart';
import 'package:frontend/presentation/components/nickname_text_field.dart';
import 'package:frontend/presentation/on_boarding/components/on_boarding_stepper.dart';
import 'package:frontend/presentation/on_boarding/on_boarding_age/on_boarding_age_screen.dart';
import 'package:frontend/presentation/on_boarding/on_boarding_nickname/on_boarding_nickname_viewmodel.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

class OnBoardingNicknameScreen extends StatefulWidget {
  final String? email;
  final String loginType;
  final String socialId;

  const OnBoardingNicknameScreen({
    Key? key,
    required this.email,
    required this.loginType,
    required this.socialId,
  }) : super(key: key);

  @override
  State<OnBoardingNicknameScreen> createState() =>
      _OnBoardingNicknameScreenState();
}

class _OnBoardingNicknameScreenState extends State<OnBoardingNicknameScreen> {
  FocusNode nicknameFocusNode = FocusNode();
  bool btnVisible = true;

  @override
  void initState() {
    getOnBoardingNickNameBinding();
    nicknameFocusNode.addListener(btnVisibleChange);
    super.initState();
  }

  @override
  void dispose() {
    nicknameFocusNode.removeListener(btnVisibleChange);
    nicknameFocusNode.dispose();
    super.dispose();
  }

  void btnVisibleChange() {
    setState(() {
      btnVisible = !nicknameFocusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnBoardingNicknameViewModel>();
    final onBoardingController = Get.find<OnBoardingController>();

    return DefaultLayout(
      screenName: 'Screen_Event_OnBoarding_NickName',
      child: WillPopScope(
        onWillPop: () async {
          bool backResult = GlobalUtils.onBackPressed();
          return await Future.value(backResult);
        },
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            body: SafeArea(
              bottom: false,
              child: FormBuilder(
                key: _fbKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: Stack(
                  children: [
                    Center(
                      child: ListView(
                        children: [
                          SizedBox(
                            height: 12.h,
                          ),
                          const OnBoardingStepper(
                            pointNumber: 1,
                          ),
                          Padding(
                            padding: kPrimarySidePadding,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 32.h,
                                ),
                                Text(
                                  "안녕하세요, 저는 하루냥이에요",
                                  style: kHeader2Style.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .textTitle),
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Text(
                                  "집사님을 어떻게 불러드릴까요?",
                                  style: kHeader2Style.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .textTitle),
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                NicknameTextField(
                                  nameHintText: '닉네임',
                                  focus: nicknameFocusNode,
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
                                              color: kBlackColor,
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
                                          height: 124.h,
                                        ),
                                ),
                                Center(
                                  child: Image.asset(
                                    "lib/config/assets/images/character/character4.png",
                                    width: 340.w,
                                    height: 340.h,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: btnVisible,
                      child: Obx(
                        () => BottomButton(
                          title: '다음',
                          onTap: controller.nicknameValue.value.isEmpty
                              ? null
                              : () async {
                                  var key = _fbKey.currentState!;
                                  if (key.saveAndValidate() ||
                                      onBoardingController
                                          .isDuplicateNickname.value) {
                                    FocusScope.of(context).unfocus();

                                    Get.to(
                                      () => OnBoardingAgeScreen(
                                        nickname:
                                            controller.nicknameValue.value,
                                        email: widget.email,
                                        loginType: widget.loginType,
                                        socialId: widget.socialId,
                                      ),
                                    );

                                    // await onBoardingController.putMyInformation(
                                    //   nickname: controller.nicknameValue.value,
                                    //   isOnBoarding: true,
                                    //   isPutNickname: true,
                                    //   context: context,
                                    // );
                                  }
                                },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
