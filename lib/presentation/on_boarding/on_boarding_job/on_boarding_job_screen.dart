import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/main_view_model.dart';
import 'package:frontend/presentation/components/bottom_button.dart';
import 'package:frontend/presentation/on_boarding/components/black_points.dart';
import 'package:frontend/presentation/on_boarding/components/job_button.dart';
import 'package:frontend/presentation/on_boarding/on_boarding_finish/on_boarding_finish_screen.dart';
import 'package:frontend/presentation/on_boarding/on_boarding_job/on_boarding_job_viewmodel.dart';
import 'package:frontend/res/constants.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class OnBoardingJobScreen extends GetView<OnBoardingJobViewModel> {
  final String nickname;
  final String birth;

  OnBoardingJobScreen({
    Key? key,
    required this.nickname,
    required this.birth,
  }) : super(key: key);
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    getOnBoardingJobBinding();

    return Scaffold(
      body: SafeArea(
        child: FormBuilder(
          key: _fbKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Stack(
            children: [
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BlackPoints(
                      blackNumber: 3,
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
                            nickname,
                            style: kHeader2BlackStyle,
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          Text(
                            "지금 어떤 일을 하고 있어?",
                            style: kHeader2BlackStyle,
                          ),
                          SizedBox(
                            height: 40.h,
                          ),
                          GridView.builder(
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Obx(
                () => BottomButton(
                  title: '끝',
                  onTap: controller.jobStatus.value == null
                      ? null
                      : () async {
                          var key = _fbKey.currentState!;
                          if (key.saveAndValidate()) {
                            FocusScope.of(context).unfocus();

                            await controller.putMyInformation(
                              nickname: nickname,
                              job: controller.jobStatus.value!.name,
                              age: birth,
                            );

                            await Get.find<MainViewModel>().getMyInformation();

                            Get.to(
                              () => const OnBoardingFinishScreen(),
                              transition: Transition.cupertino,
                            );
                          }
                        },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
