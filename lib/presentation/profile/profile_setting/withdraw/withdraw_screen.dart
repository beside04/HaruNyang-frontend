import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/global_controller/on_boarding/on_boarding_controller.dart';
import 'package:frontend/presentation/components/back_icon.dart';
import 'package:frontend/presentation/components/bottom_button.dart';
import 'package:frontend/presentation/components/dialog_button.dart';
import 'package:frontend/presentation/components/dialog_component.dart';
import 'package:frontend/presentation/profile/profile_setting/withdraw/component/withdraw_done_screen.dart';
import 'package:frontend/presentation/profile/profile_setting/withdraw/withdraw_view_model.dart';
import 'package:get/get.dart';

import '../../../../core/utils/utils.dart';

class WithdrawScreen extends GetView<WithdrawViewModel> {
  final bool isKakaoLogin;

  const WithdrawScreen({
    Key? key,
    required this.isKakaoLogin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      screenName: 'Screen_Event_Profile_MyInformation_Withdraw',
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            '회원 탈퇴',
            style: kHeader4Style.copyWith(
                color: Theme.of(context).colorScheme.textTitle),
          ),
          elevation: 0,
          leading: BackIcon(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: kPrimaryPadding,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.asset(
                            "lib/config/assets/images/character/haru_error_case.png",
                            width: 160.w,
                            height: 160.h,
                          ),
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(const WithdrawDoneScreen());
                          },
                          child: Center(
                            child: Text(
                              '탈퇴 전 확인하세요!',
                              style: kHeader3Style.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.textTitle),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        Container(
                          padding: kPrimaryPadding,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Theme.of(context).colorScheme.surface_01,
                          ),
                          child: Text(
                            '가입 시 수집한 개인정보(이메일)를 포함하여 작성한\n 일기, 기분, 감정캘린더, 발급받은 감정리포트가\n 영구적으로 삭제되며, 다시는 복구할 수 없습니다.',
                            style: kBody3Style.copyWith(
                                color:
                                    Theme.of(context).colorScheme.textSubtitle),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.changeWithdrawTerms(
                                !controller.state.value.isAgreeWithdrawTerms);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Obx(
                                () => SizedBox(
                                  width: 20.w,
                                  height: 20.h,
                                  child: Checkbox(
                                    activeColor: kOrange300Color,
                                    value: controller
                                        .state.value.isAgreeWithdrawTerms,
                                    onChanged: (value) {
                                      if (value != null) {
                                        controller.changeWithdrawTerms(value);
                                      }
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0.w),
                                child: Text(
                                  '안내사항을 확인하였으며 이에 동의합니다.',
                                  style: kBody2Style.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .textBody),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Obx(
              () => BottomButton(
                title: "탈퇴하기",
                onTap: controller.state.value.isAgreeWithdrawTerms
                    ? () {
                        GlobalUtils.setAnalyticsCustomEvent(
                            'Click_Withdraw_Done');
                        showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (context) {
                            return DialogComponent(
                              title: "정말 탈퇴 하시겠어요?",
                              content: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0),
                                child: Text(
                                  "탈퇴하면 더이상 하루냥과 함께 할 수 없어요.",
                                  style: kHeader6Style.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .textSubtitle),
                                ),
                              ),
                              actionContent: [
                                DialogButton(
                                  title: "아니요",
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .secondaryColor,
                                  textStyle: kHeader4Style.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .textSubtitle),
                                ),
                                SizedBox(
                                  width: 12.w,
                                ),
                                DialogButton(
                                  title: "탈퇴하기",
                                  onTap: () async {
                                    final result = await controller
                                        .withdrawUser(isKakaoLogin);
                                    if (result) {
                                      Get.find<OnBoardingController>()
                                          .clearMyInformation();
                                      Get.offAll(
                                        () => const WithdrawDoneScreen(),
                                      );
                                    } else {
                                      Get.back();
                                      Get.snackbar('알림', '회원 탈퇴에 실패했습니다.');
                                    }
                                  },
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primaryColor,
                                  textStyle: kHeader4Style.copyWith(
                                    color: kWhiteColor,
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
