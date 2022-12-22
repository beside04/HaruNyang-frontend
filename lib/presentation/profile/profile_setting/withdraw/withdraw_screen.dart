import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/presentation/components/dialog_button.dart';
import 'package:frontend/presentation/components/dialog_component.dart';
import 'package:frontend/presentation/profile/profile_setting/withdraw/component/withdraw_done_screen.dart';
import 'package:frontend/presentation/profile/profile_setting/withdraw/withdraw_view_model.dart';
import 'package:get/get.dart';

class WithdrawScreen extends GetView<WithdrawViewModel> {
  final bool isKakaoLogin;

  const WithdrawScreen({
    Key? key,
    required this.isKakaoLogin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: kBlackColor),
        backgroundColor: kWhiteColor,
        title: Text(
          '회원 탈퇴',
          style: kHeader2BlackStyle,
        ),
        centerTitle: false,
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
      body: Padding(
        padding: kPrimaryPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 20.h,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                    width: 120.w,
                    height: 120.h,
                    child: CircleAvatar(
                      backgroundColor: kPrimary2Color,
                      child: SvgPicture.asset(
                        "lib/config/assets/images/character/sad1.svg",
                        width: 100.w,
                        height: 100.h,
                      ),
                    ),
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
                      style: kHeader2BlackStyle,
                    ),
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Container(
                  padding: kPrimaryPadding,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: kSecondaryColor,
                  ),
                  child: Text(
                    '가입 시 수집한 개인정보(이메일)를 포함하여 작성한\n 일기, 기분, 감정캘린더, 발급받은 감정리포트가\n 영구적으로 삭제되며, 다시는 복구할 수 없습니다.',
                    style: kBody2BlackStyle,
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
                            activeColor: kPrimaryColor,
                            value: controller.state.value.isAgreeWithdrawTerms,
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
                          style: kBody1BlackStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: kPrimaryPadding,
              child: Center(
                child: Obx(
                  () => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60),
                      ),
                    ),
                    onPressed: controller.state.value.isAgreeWithdrawTerms
                        ? () {
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
                                      style: kSubtitle3Gray600Style,
                                    ),
                                  ),
                                  actionContent: [
                                    DialogButton(
                                      title: "아니요",
                                      onTap: () {
                                        Get.back();
                                        Get.back();
                                      },
                                      backgroundColor: kGrayColor100,
                                      textStyle: kSubtitle1Gray600Style,
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
                                          Get.offAll(
                                            () => const WithdrawDoneScreen(),
                                          );
                                        } else {
                                          Get.back();
                                          Get.snackbar('알림', '회원 탈퇴에 실패했습니다.');
                                        }
                                      },
                                      backgroundColor: kPrimary2Color,
                                      textStyle: kSubtitle1WhiteStyle,
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        : null,
                    child: const Text('탈퇴하기'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
