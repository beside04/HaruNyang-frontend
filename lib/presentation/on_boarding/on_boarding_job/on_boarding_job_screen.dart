import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/presentation/home/home_screen.dart';
import 'package:frontend/presentation/on_boarding/components/black_points.dart';
import 'package:frontend/presentation/on_boarding/components/job_button.dart';
import 'package:frontend/presentation/on_boarding/on_boarding_job/on_boarding_job_viewmodel.dart';
import 'package:frontend/res/constants.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class OnBoardingJobScreen extends GetView<OnBoardingJobViewModel> {
  final String socialId;

  OnBoardingJobScreen({
    Key? key,
    required this.socialId,
  }) : super(key: key);
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    getOnBoardingJobBinding();

    return Scaffold(
      body: FormBuilder(
        key: _fbKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(left: 16.0.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 93.h,
                    ),
                    const BlackPoints(
                      blackNumber: 3,
                    ),
                    SizedBox(
                      height: 7.h,
                    ),
                    Text(
                      "직업에 대해 알려주세요!",
                      style: kHeader1BlackStyle,
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                    SizedBox(
                      width: 349.w,
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: controller.jobList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3,
                          mainAxisSpacing: 20.h,
                          crossAxisSpacing: 9.w,
                        ),
                        itemBuilder: (BuildContext context, int i) {
                          return Obx(() => JobButton(
                                controller.jobList[i],
                                selected:
                                    controller.jobStatus.value == Job.values[i],
                                onPressed: () {
                                  controller.jobStatus.value = Job.values[i];
                                },
                              ));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 28.w,
                  bottom: 37.h,
                  right: 31.w,
                ),
                child: SizedBox(
                  width: 331.w,
                  height: 48.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kBlackColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      var key = _fbKey.currentState!;
                      if (key.saveAndValidate()) {
                        FocusScope.of(context).unfocus();

                        await controller.login(socialId);

                        Get.offAll(
                          () => const HomeScreen(),
                          transition: Transition.cupertino,
                        );
                      }
                    },
                    child: Text(
                      "다음",
                      style: kSubtitle2WhiteStyle,
                    ),
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
