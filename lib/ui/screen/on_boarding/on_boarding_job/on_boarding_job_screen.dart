import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/domains/notification/provider/notification_provider.dart';
import 'package:frontend/domains/on_boarding/provider/on_boarding_job/on_boarding_job_provider.dart';
import 'package:frontend/domains/on_boarding/provider/on_boarding_provider.dart';
import 'package:frontend/res/constants.dart';
import 'package:frontend/ui/components/bottom_button.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:frontend/ui/screen/on_boarding/components/job_button.dart';
import 'package:frontend/ui/screen/on_boarding/components/on_boarding_stepper.dart';
import 'package:frontend/ui/screen/on_boarding/on_boarding_finish/on_boarding_finish_screen.dart';

class OnBoardingJobScreen extends ConsumerWidget {
  final String nickname;
  final String? birth;
  final String? email;
  final String loginType;
  final String socialId;

  OnBoardingJobScreen({
    Key? key,
    required this.nickname,
    required this.birth,
    required this.email,
    required this.loginType,
    required this.socialId,
  }) : super(key: key);
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      screenName: 'Screen_Event_OnBoarding_Job',
      child: Scaffold(
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
                      SizedBox(
                        height: 12.h,
                      ),
                      const OnBoardingStepper(
                        pointNumber: 3,
                      ),
                      Padding(
                        padding: kPrimarySidePadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 32.h,
                            ),
                            Text(
                              "어떤 일을",
                              style: kHeader2Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Text(
                              "하고 계세요?",
                              style: kHeader2Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                            ),
                            SizedBox(
                              height: 40.h,
                            ),
                            GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: jobList.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 0.8.h,
                                mainAxisSpacing: 20.0.h,
                              ),
                              itemBuilder: (BuildContext context, int i) {
                                return Consumer(builder: (context, ref, child) {
                                  return JobButton(
                                    job: jobList[i].name,
                                    icon: jobList[i].icon,
                                    selected: ref.watch(onBoardingJobProvider) == Job.values[i],
                                    onPressed: () {
                                      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
                                      ref.watch(onBoardingJobProvider.notifier).state = Job.values[i];
                                    },
                                  );
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Consumer(builder: (context, ref, child) {
                  return BottomButton(
                    title: '다음',
                    onTap: ref.watch(onBoardingJobProvider) == null
                        ? null
                        : () async {
                            var key = _fbKey.currentState!;
                            if (key.saveAndValidate()) {
                              FocusScope.of(context).unfocus();

                              final container = ProviderContainer();

                              var deviceToken = container.read(notificationProvider).token;

                              await ref.watch(onBoardingProvider.notifier).postSignUp(
                                    email: email,
                                    loginType: loginType,
                                    socialId: socialId,
                                    deviceId: deviceToken,
                                    nickname: nickname,
                                    job: ref.watch(onBoardingJobProvider)!.name,
                                    birthDate: birth,
                                  );

                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (context) => OnBoardingFinishScreen(
                                    loginType: loginType,
                                  ),
                                ),
                              );
                            }
                          },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
