import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/presentation/profile/profile_setting/withdraw/withdraw_view_model.dart';
import 'package:get/get.dart';

class WithdrawScreen extends GetView<WithdrawViewModel> {
  const WithdrawScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원 탈퇴'),
        centerTitle: false,
      ),
      body: Padding(
        padding: kPrimaryPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '탈퇴전 확인하세요!',
              style: kSubtitle2BlackStyle,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: CircleAvatar(
                      backgroundColor: kPrimaryColor,
                      child: Transform.translate(
                        offset: const Offset(6, 5),
                        child: SvgPicture.asset(
                          "lib/config/assets/images/character/onboarding1.svg",
                          width: 90,
                          height: 90,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
                Container(
                  padding: kPrimaryPadding,
                  decoration: const BoxDecoration(
                    color: kSecondaryColor,
                  ),
                  child: Text(
                    '가입 시 수집한 개인정보(이메일)를 포함하여 작성한 일기, 기분, 감정캘린더, 발급받은 감정리포트가 영구적으로 삭제되며, 다시는 복구할 수 없습니다.',
                    style: kBody2BlackStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  children: [
                    Obx(
                      () => Checkbox(
                        activeColor: kPrimaryColor,
                        value: controller.state.value.isAgreeWithdrawTerms,
                        onChanged: (value) {
                          if (value != null) {
                            controller.changeWithdrawTerms(value);
                          }
                        },
                      ),
                    ),
                    Text(
                      '안내사항을 확인하였으며 이에 동의합니다.',
                      style: kBody1BlackStyle,
                    ),
                  ],
                )
              ],
            ),
            Center(
              child: Obx(
                () => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    minimumSize: const Size(150, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: controller.state.value.isAgreeWithdrawTerms
                      ? () {
                          controller.withdrawUser();
                        }
                      : null,
                  child: const Text('회원 탈퇴'),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
