import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/global_controller/on_boarding/on_boarding_controller.dart';
import 'package:frontend/presentation/components/bottom_button.dart';
import 'package:frontend/presentation/on_boarding/components/on_boarding_stepper.dart';
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
  final onBoardingController = Get.find<OnBoardingController>();

  @override
  Widget build(BuildContext context) {
    getOnBoardingJobBinding();

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: FormBuilder(
          key: _fbKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Stack(
            children: [
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const OnBoardingStepper(
                      pointNumber: 3,
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
                            "어떤 일을",
                            style: kHeader2Style.copyWith(
                                color: Theme.of(context).colorScheme.textTitle),
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          Text(
                            "하고 계세요?",
                            style: kHeader2Style.copyWith(
                                color: Theme.of(context).colorScheme.textTitle),
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
                  title: '다음',
                  onTap: controller.jobStatus.value == null
                      ? null
                      : () async {
                          var key = _fbKey.currentState!;
                          if (key.saveAndValidate()) {
                            FocusScope.of(context).unfocus();

                            await onBoardingController.putMyInformation(
                              nickname: nickname,
                              job: controller.jobStatus.value!.name,
                              age: birth,
                              isPutNickname: false,
                              isOnBoarding: false,
                            );

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
