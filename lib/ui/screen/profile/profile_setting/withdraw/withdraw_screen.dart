import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/core/utils/utils.dart';
import 'package:frontend/domains/on_boarding/provider/on_boarding_provider.dart';
import 'package:frontend/domains/profile/provider/profile_setting/withdraw_provider.dart';
import 'package:frontend/ui/components/back_icon.dart';
import 'package:frontend/ui/components/bottom_button.dart';
import 'package:frontend/ui/components/dialog_button.dart';
import 'package:frontend/ui/components/dialog_component.dart';
import 'package:frontend/ui/layout/default_layout.dart';
import 'package:frontend/ui/screen/profile/profile_setting/withdraw/component/withdraw_done_screen.dart';

class WithdrawScreen extends ConsumerWidget {
  final bool isKakaoLogin;

  const WithdrawScreen({
    Key? key,
    required this.isKakaoLogin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      screenName: 'Screen_Event_Profile_MyInformation_Withdraw',
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            '회원 탈퇴',
            style: kHeader4Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
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
                            height: 150.h,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => WithdrawDoneScreen()),
                            );
                          },
                          child: Center(
                            child: Text(
                              '탈퇴 전 확인하세요!',
                              style: kHeader3Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
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
                            style: kBody3Style.copyWith(color: Theme.of(context).colorScheme.textSubtitle),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Consumer(builder: (context, ref, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      ref.watch(withdrawProvider.notifier).changeWithdrawTerms(!ref.watch(withdrawProvider).isAgreeWithdrawTerms);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 24.0.w, bottom: 20.h),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Theme.of(context).colorScheme.brightness == Brightness.dark
                              ? Consumer(builder: (context, ref, child) {
                                  return SizedBox(
                                    width: 24.w,
                                    height: 24.h,
                                    child: ref.watch(withdrawProvider).isAgreeWithdrawTerms
                                        ? Image.asset(
                                            "lib/config/assets/images/check/round_check_primary.png",
                                          )
                                        : Image.asset(
                                            "lib/config/assets/images/check/round_check_dark_mode.png",
                                          ),
                                  );
                                })
                              : Consumer(builder: (context, ref, child) {
                                  return SizedBox(
                                    width: 24.w,
                                    height: 24.h,
                                    child: ref.watch(withdrawProvider).isAgreeWithdrawTerms
                                        ? Image.asset(
                                            "lib/config/assets/images/check/round_check_primary.png",
                                          )
                                        : Image.asset(
                                            "lib/config/assets/images/check/round_check_light_mode.png",
                                          ),
                                  );
                                }),
                          Padding(
                            padding: EdgeInsets.all(8.0.w),
                            child: Text(
                              '안내사항을 확인하였으며 이에 동의합니다.',
                              style: kHeader6Style.copyWith(color: Theme.of(context).colorScheme.textBody),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  BottomButton(
                    title: "탈퇴하기",
                    onTap: ref.watch(withdrawProvider).isAgreeWithdrawTerms
                        ? () {
                            GlobalUtils.setAnalyticsCustomEvent('Click_Withdraw_Done');
                            showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (context) {
                                return DialogComponent(
                                  title: "정말 탈퇴 하시겠어요?",
                                  content: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                                    child: Text(
                                      "탈퇴하면 더이상 하루냥과 함께 할 수 없어요.",
                                      style: kHeader6Style.copyWith(color: Theme.of(context).colorScheme.textSubtitle),
                                    ),
                                  ),
                                  actionContent: [
                                    DialogButton(
                                      title: "아니요",
                                      onTap: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      backgroundColor: Theme.of(context).colorScheme.secondaryColor,
                                      textStyle: kHeader4Style.copyWith(color: Theme.of(context).colorScheme.textSubtitle),
                                    ),
                                    SizedBox(
                                      width: 12.w,
                                    ),
                                    DialogButton(
                                      title: "탈퇴하기",
                                      onTap: () async {
                                        final result = await ref.watch(withdrawProvider.notifier).withdrawUser(isKakaoLogin);
                                        if (result) {
                                          ref.watch(onBoardingProvider.notifier).clearMyInformation();

                                          Navigator.of(context).pushAndRemoveUntil(
                                              MaterialPageRoute(
                                                builder: (context) => const WithdrawDoneScreen(),
                                              ),
                                              (route) => false);
                                        } else {
                                          Navigator.pop(context);
                                          // Get.snackbar('알림', '회원 탈퇴에 실패했습니다.');
                                        }
                                      },
                                      backgroundColor: Theme.of(context).colorScheme.primaryColor,
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
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
