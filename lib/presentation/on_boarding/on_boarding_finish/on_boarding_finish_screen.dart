import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/presentation/components/bottom_button.dart';
import 'package:frontend/presentation/home/home_screen.dart';
import 'package:frontend/presentation/login/login_view_model.dart';
import 'package:frontend/presentation/on_boarding/components/on_boarding_stepper.dart';
import 'package:frontend/presentation/on_boarding/on_boarding_finish/on_boarding_finish_viewmodel.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class OnBoardingFinishScreen extends GetView<OnBoardingFinishViewModel> {
  OnBoardingFinishScreen({
    required this.loginType,
    Key? key,
  }) : super(key: key);

  String loginType;

  @override
  Widget build(BuildContext context) {
    getOnBoardingFinishBinding();

    return DefaultLayout(
      screenName: 'Screen_Event_OnBoarding_Done',
      child: WillPopScope(
        onWillPop: () async {
          Get.offAll(
            () => const HomeScreen(),
            transition: Transition.cupertino,
            binding: BindingsBuilder(
              getHomeViewModelBinding,
            ),
          );
          return false;
        },
        child: Scaffold(
          body: SafeArea(
            bottom: false,
            child: Stack(
              children: [
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 12.h,
                      ),
                      const OnBoardingStepper(
                        pointNumber: 4,
                      ),
                      Padding(
                        padding: kPrimarySidePadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 24.h,
                            ),
                            Text(
                              "하루냥의",
                              style: kHeader2Style.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.textTitle),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Text(
                              "집사 등록이 완료되었어요!",
                              style: kHeader2Style.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.textTitle),
                            ),
                            SizedBox(
                              height: 158.h,
                            ),
                            Center(
                              child: Image.asset(
                                "lib/config/assets/images/character/character8.png",
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
                BottomButton(
                  title: '시작하기',
                  onTap: () async {
                    controller.setPushMessage();

                    await Get.find<LoginViewModel>().getLoginSuccessData(
                        isSocialKakao: loginType == "KAKAO" ? true : false);

                    Get.offAll(
                      () => const HomeScreen(),
                      arguments: {"index": 1},
                      transition: Transition.cupertino,
                      binding: BindingsBuilder(
                        getHomeViewModelBinding,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
