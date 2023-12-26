import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/core/utils/library/date_time_spinner/date_picker_theme.dart' as picker_theme;
import 'package:frontend/core/utils/library/date_time_spinner/date_time_spinner.dart';
import 'package:frontend/core/utils/library/date_time_spinner/i18n_model.dart';
import 'package:frontend/domains/on_boarding/provider/on_boarding_age/on_boarding_age_provider.dart';
import 'package:frontend/ui/components/age_text_field.dart';
import 'package:frontend/ui/components/bottom_button.dart';
import 'package:frontend/ui/screen/on_boarding/components/on_boarding_stepper.dart';
import 'package:frontend/ui/screen/on_boarding/on_boarding_job/on_boarding_job_screen.dart';

class OnBoardingAgeScreen extends ConsumerWidget {
  final String nickname;
  final String? email;
  final String loginType;
  final String socialId;

  OnBoardingAgeScreen({
    Key? key,
    required this.nickname,
    required this.email,
    required this.loginType,
    required this.socialId,
  }) : super(key: key);
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      screenName: 'Screen_Event_OnBoarding_Age',
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
                        pointNumber: 2,
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
                              "몇 살이예요? \n하루냥이 생일을 축하해드려요!",
                              style: kHeader2Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                            ),
                            SizedBox(
                              height: 40.h,
                            ),
                            AgeTextField(
                              onChanged: (value) {},
                              isSettingAge: false,
                              textEditingController: ref.watch(onBoardingAgeProvider.notifier).ageEditingController,
                              onTap: () {
                                DatePicker.showDatePicker(
                                  context,
                                  showTitleActions: true,
                                  minTime: DateTime(1930, 1, 1),
                                  maxTime: DateTime(2022, 12, 31),
                                  onConfirm: (date) {
                                    ref.watch(onBoardingAgeProvider.notifier).getBirthDateFormat(date);
                                  },
                                  currentTime: DateTime(2000, 01, 01),
                                  locale: LocaleType.ko,
                                  theme: picker_theme.DatePickerTheme(
                                    itemStyle: kSubtitle1Style.copyWith(color: Theme.of(context).colorScheme.textBody),
                                    backgroundColor: Theme.of(context).colorScheme.backgroundModal,
                                    title: "나이 입력하기",
                                  ),
                                );
                              },
                              suffixIcon: Consumer(builder: (context, ref, child) {
                                return ref.watch(onBoardingAgeProvider).isEmpty
                                    ? Visibility(
                                        visible: false,
                                        child: Container(),
                                      )
                                    : GestureDetector(
                                        child: Icon(
                                          Icons.cancel,
                                          color: Theme.of(context).colorScheme.iconSubColor,
                                          size: 20,
                                        ),
                                        onTap: () => ref.watch(onBoardingAgeProvider.notifier).ageEditingController.clear(),
                                      );
                              }),
                              hintText: "2000-01-01",
                            ),
                            SizedBox(
                              height: 106.h,
                            ),
                            Center(
                              child: Image.asset(
                                "lib/config/assets/images/character/character2.png",
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
                  title: '다음',
                  onTap: () {
                    var key = _fbKey.currentState!;
                    if (key.saveAndValidate()) {
                      FocusScope.of(context).unfocus();
                      Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => OnBoardingJobScreen(
                          nickname: nickname,
                          birth: ref.watch(onBoardingAgeProvider),
                          email: email,
                          loginType: loginType,
                          socialId: socialId,
                        ),
                      ));
                    }
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
