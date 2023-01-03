import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/main_view_model.dart';
import 'package:frontend/presentation/components/age_text_field.dart';
import 'package:frontend/presentation/components/bottom_button.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '내 정보 관리',
          style: Theme.of(context).textTheme.headline3,
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
              color: Theme.of(context).colorScheme.surface,
            ),
            ProfileButton(
              icon: const Icon(
                Icons.navigate_next,
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
                              style: kHeader4BlackStyle,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(24.w),
                            child: NicknameTextField(
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
                                          // color: kGrayColor200,
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

                                        await controller.putMyInformation(
                                          nickname:
                                              controller.nicknameValue.value,
                                          job: Get.find<MainViewModel>()
                                              .state
                                              .value
                                              .job,
                                          age: Get.find<MainViewModel>()
                                              .state
                                              .value
                                              .age,
                                        );

                                        await Get.find<MainViewModel>()
                                            .getMyInformation();

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
            ProfileButton(
              icon: const Icon(
                Icons.navigate_next,
                // color: kGrayColor250,
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
                              style: kHeader4BlackStyle,
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
                                  maxTime: DateTime(2005, 12, 30),
                                  onConfirm: (date) {
                                    controller.getBirthDateFormat(date);
                                  },
                                  currentTime: DateTime.parse(
                                    Get.find<MainViewModel>().state.value.age!,
                                  ),
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
                                          // color: kGrayColor200,
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

                                        await controller.putMyInformation(
                                          nickname: Get.find<MainViewModel>()
                                              .state
                                              .value
                                              .nickname,
                                          job: Get.find<MainViewModel>()
                                              .state
                                              .value
                                              .job,
                                          age: controller.ageValue.value,
                                        );

                                        await Get.find<MainViewModel>()
                                            .getMyInformation();

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
            ProfileButton(
              icon: const Icon(
                Icons.navigate_next,
                // color: kGrayColor250,
              ),
              title: '직업 수정',
              onPressed: () {
                controller.jobStatus.value = EnumToString.fromString(
                    Job.values, "${Get.find<MainViewModel>().state.value.job}");
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
                            style: kHeader4BlackStyle,
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
                                    await controller.putMyInformation(
                                      nickname: Get.find<MainViewModel>()
                                          .state
                                          .value
                                          .nickname,
                                      job: controller.jobStatus.value!.name,
                                      age: Get.find<MainViewModel>()
                                          .state
                                          .value
                                          .age,
                                    );

                                    await Get.find<MainViewModel>()
                                        .getMyInformation();

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
              color: Theme.of(context).colorScheme.surface,
            ),
            ProfileButton(
              icon: const Icon(
                Icons.navigate_next,
                // color: kGrayColor250,
              ),
              title: '로그아웃',
              onPressed: () async {
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
