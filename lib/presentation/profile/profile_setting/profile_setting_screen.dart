import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/core/utils/library/date_time_spinner/date_picker_theme.dart';
import 'package:frontend/core/utils/library/date_time_spinner/date_time_spinner.dart';
import 'package:frontend/core/utils/library/date_time_spinner/i18n_model.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/global_controller/on_boarding/on_boarding_controller.dart';
import 'package:frontend/presentation/components/age_text_field.dart';
import 'package:frontend/presentation/components/bottom_button.dart';
import 'package:frontend/presentation/components/dialog_button.dart';
import 'package:frontend/presentation/components/dialog_component.dart';
import 'package:frontend/presentation/components/nickname_text_field.dart';
import 'package:frontend/presentation/login/login_screen.dart';
import 'package:frontend/presentation/on_boarding/components/job_button.dart';
import 'package:frontend/presentation/profile/components/profile_button.dart';
import 'package:frontend/presentation/profile/profile_setting/profile_setting_view_model.dart';
import 'package:frontend/presentation/profile/profile_setting/withdraw/withdraw_screen.dart';
import 'package:frontend/res/constants.dart';
import 'package:get/get.dart';

class ProfileSettingScreen extends GetView<ProfileSettingViewModel> {
  final bool isKakaoLogin;

  ProfileSettingScreen({
    Key? key,
    required this.isKakaoLogin,
  }) : super(key: key);

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final onBoardingController = Get.find<OnBoardingController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '내 정보 관리',
          style: kHeader3Style.copyWith(
              color: Theme.of(context).colorScheme.textTitle),
        ),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Divider(
              thickness: 12.h,
            ),
            ProfileButton(
              icon: SvgPicture.asset(
                "lib/config/assets/images/profile/navigate_next.svg",
              ),
              title: '닉네임 수정',
              onPressed: () {
                showModalBottomSheet(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25.0),
                    ),
                  ),
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => FormBuilder(
                    key: _fbKey,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 40.0.h,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 24.0.w),
                            child: Text(
                              "닉네임 변경",
                              style: kHeader4Style.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.textTitle),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(24.w),
                            child: NicknameTextField(
                              nameHintText:
                                  onBoardingController.state.value.nickname,
                              textEditingController:
                                  controller.nicknameEditingController,
                              suffixIcon: Obx(
                                () => controller.nicknameValue.value.isEmpty
                                    ? Visibility(
                                        visible: false,
                                        child: Container(),
                                      )
                                    : GestureDetector(
                                        child: Icon(
                                          Icons.cancel,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .iconColor,
                                          size: 20,
                                        ),
                                        onTap: () => controller
                                            .nicknameEditingController
                                            .clear(),
                                      ),
                              ),
                            ),
                          ),
                          Obx(
                            () => BottomButton(
                              title: '변경하기',
                              onTap: controller.nicknameValue.value.isEmpty
                                  ? null
                                  : () async {
                                      var key = _fbKey.currentState!;
                                      if (key.saveAndValidate()) {
                                        FocusScope.of(context).unfocus();

                                        await onBoardingController
                                            .putMyInformation(
                                          nickname:
                                              controller.nicknameValue.value,
                                        );

                                        Get.back();
                                      }
                                    },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            Divider(
              thickness: 1.h,
              height: 1.h,
              color: Theme.of(context).colorScheme.border,
            ),
            ProfileButton(
              icon: SvgPicture.asset(
                "lib/config/assets/images/profile/navigate_next.svg",
              ),
              title: '나이 수정',
              onPressed: () {
                showModalBottomSheet(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25.0),
                    ),
                  ),
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => FormBuilder(
                    key: _fbKey,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 40.0.h,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 24.0.w),
                            child: Text(
                              "날짜 변경",
                              style: kHeader4Style.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.textTitle),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(24.w),
                            child: AgeTextField(
                              textEditingController:
                                  controller.ageEditingController,
                              onTap: () {
                                DatePicker.showDatePicker(
                                  context,
                                  showTitleActions: true,
                                  minTime: DateTime(1930, 1, 1),
                                  maxTime: DateTime(2022, 12, 31),
                                  onConfirm: (date) {
                                    controller.getBirthDateFormat(date);
                                  },
                                  currentTime: DateTime.parse(
                                    onBoardingController.state.value.age,
                                  ),
                                  locale: LocaleType.ko,
                                  theme: DatePickerTheme(
                                    itemStyle: kSubtitle1Style.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .textBody),
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .backgroundModal,
                                    title: "나이 수정",
                                  ),
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
                          ),
                          Obx(
                            () => BottomButton(
                              title: '변경하기',
                              onTap: controller.ageValue.value.isEmpty
                                  ? null
                                  : () async {
                                      var key = _fbKey.currentState!;
                                      if (key.saveAndValidate()) {
                                        FocusScope.of(context).unfocus();

                                        await onBoardingController
                                            .putMyInformation(
                                          age: controller.ageValue.value,
                                        );

                                        Get.back();
                                      }
                                    },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            Divider(
              thickness: 1.h,
              height: 1.h,
              color: Theme.of(context).colorScheme.border,
            ),
            ProfileButton(
              icon: SvgPicture.asset(
                "lib/config/assets/images/profile/navigate_next.svg",
              ),
              title: '직업 수정',
              onPressed: () {
                controller.jobStatus.value = EnumToString.fromString(
                    Job.values, onBoardingController.state.value.job);
                showModalBottomSheet(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25.0),
                    ),
                  ),
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 40.0.h,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 24.0.w),
                          child: Text(
                            "직업 변경",
                            style: kHeader4Style.copyWith(
                                color: Theme.of(context).colorScheme.textTitle),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0.h),
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: jobList.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 0.8.h,
                            ),
                            itemBuilder: (BuildContext context, int i) {
                              return Obx(() => JobButton(
                                    job: jobList[i].name,
                                    icon: jobList[i].icon,
                                    selected: controller.jobStatus.value ==
                                        Job.values[i],
                                    onPressed: () {
                                      controller.jobStatus.value =
                                          Job.values[i];
                                    },
                                  ));
                            },
                          ),
                        ),
                        Obx(
                          () => BottomButton(
                            title: '변경하기',
                            onTap: controller.jobStatus.value == null
                                ? null
                                : () async {
                                    await onBoardingController.putMyInformation(
                                      job: controller.jobStatus.value!.name,
                                    );

                                    Get.back();
                                  },
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
            Divider(
              thickness: 12.h,
            ),
            ProfileButton(
              icon: SvgPicture.asset(
                "lib/config/assets/images/profile/navigate_next.svg",
              ),
              title: '로그아웃',
              onPressed: () async {
                showDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (ctx) {
                    return DialogComponent(
                      title: "로그아웃 하시겠어요?",
                      content: Text(
                        "다음에 또 만나요!",
                        style: kHeader6Style.copyWith(
                            color: Theme.of(context).colorScheme.textSubtitle),
                      ),
                      actionContent: [
                        DialogButton(
                          title: "아니요",
                          onTap: () {
                            Get.back();
                          },
                          backgroundColor:
                              Theme.of(context).colorScheme.secondaryColor,
                          textStyle: kHeader4Style.copyWith(
                              color:
                                  Theme.of(context).colorScheme.textSubtitle),
                        ),
                        SizedBox(
                          width: 12.w,
                        ),
                        DialogButton(
                          title: "예",
                          onTap: () async {
                            isKakaoLogin
                                ? await controller.kakaoLogout()
                                : await controller.appleLogout();
                            Get.offAll(
                              const LoginScreen(),
                              binding: BindingsBuilder(
                                getLoginBinding,
                              ),
                            );
                          },
                          backgroundColor: kOrange200Color,
                          textStyle: kHeader4Style.copyWith(color: kWhiteColor),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            GestureDetector(
              onTap: () {
                Get.to(
                  () => WithdrawScreen(
                    isKakaoLogin: isKakaoLogin,
                  ),
                  binding: BindingsBuilder(
                    getWithdrawViewModelBinding,
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  '회원탈퇴',
                  style: kHeader5Gray300UnderlineStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
