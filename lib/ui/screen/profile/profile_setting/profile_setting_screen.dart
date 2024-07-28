import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/config/constants.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/providers/login/provider/login_provider.dart';
import 'package:frontend/providers/on_boarding/provider/on_boarding_provider.dart';
import 'package:frontend/ui/components/age_text_field.dart';
import 'package:frontend/ui/components/back_icon.dart';
import 'package:frontend/ui/components/bottom_button.dart';
import 'package:frontend/ui/components/dialog_button.dart';
import 'package:frontend/ui/components/dialog_component.dart';
import 'package:frontend/ui/components/nickname_text_field.dart';
import 'package:frontend/ui/components/toast.dart';
import 'package:frontend/ui/layout/default_layout.dart';
import 'package:frontend/ui/screen/login/login_screen.dart';
import 'package:frontend/ui/screen/on_boarding/components/job_button.dart';
import 'package:frontend/ui/screen/profile/components/profile_button.dart';
import 'package:frontend/ui/screen/profile/profile_setting/withdraw/withdraw_screen.dart';
import 'package:frontend/utils/library/date_time_spinner/base_picker_model.dart';
import 'package:frontend/utils/library/date_time_spinner/date_picker_theme.dart' as picker_theme;
import 'package:frontend/utils/library/date_time_spinner/date_time_spinner.dart';
import 'package:frontend/utils/library/date_time_spinner/i18n_model.dart';
import 'package:frontend/utils/utils.dart';
import 'package:intl/intl.dart';

class MonthDayModel extends DatePickerModel {
  MonthDayModel({required DateTime currentTime, required DateTime maxTime, required DateTime minTime, required LocaleType locale})
      : super(currentTime: currentTime, maxTime: maxTime, minTime: minTime, locale: locale);

  @override
  List<int> layoutProportions() {
    return [0, 1, 1];
  }
}

class ProfileSettingScreen extends ConsumerStatefulWidget {
  final bool isKakaoLogin;

  const ProfileSettingScreen({
    Key? key,
    required this.isKakaoLogin,
  }) : super(key: key);

  @override
  ProfileSettingScreenState createState() => ProfileSettingScreenState();
}

class ProfileSettingScreenState extends ConsumerState<ProfileSettingScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  TextEditingController nicknameEditingController = TextEditingController();
  TextEditingController ageEditingController = TextEditingController();

  void getBirthDateFormat(date) {
    ageEditingController.text = DateFormat('MM-dd').format(date);
  }

  Job? jobStatus;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    nicknameEditingController.dispose();
    ageEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      screenName: 'Screen_Event_Profile_MyInformation',
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '내 정보 관리',
            style: kHeader4Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
          ),
          elevation: 0,
          leading: BackIcon(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
          child: ListView(
            children: [
              Divider(
                thickness: 12.h,
              ),
              ProfileButton(
                icon: SvgPicture.asset(
                  "lib/config/assets/images/profile/navigate_next.svg",
                  color: Theme.of(context).colorScheme.iconSubColor,
                ),
                title: '닉네임 변경',
                titleColor: Theme.of(context).colorScheme.textTitle,
                onPressed: () {
                  GlobalUtils.setAnalyticsCustomEvent('Click_MyInfo_NickNameEdit');
                  showModalBottomSheet(
                    backgroundColor: Theme.of(context).colorScheme.backgroundModal,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25.0),
                      ),
                    ),
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => StatefulBuilder(builder: (context, StateSetter setState) {
                      return FormBuilder(
                        key: _fbKey,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 40.0.h,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 24.0.w),
                                child: Text(
                                  "닉네임 변경",
                                  style: kHeader4Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(24.w),
                                child: NicknameTextField(
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                  nameHintText: ref.watch(onBoardingProvider).nickname,
                                  textEditingController: nicknameEditingController,
                                  suffixIcon: Consumer(builder: (context, ref, child) {
                                    return nicknameEditingController.text.isEmpty
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
                                            onTap: () {
                                              nicknameEditingController.clear();
                                              setState(() {});
                                            },
                                          );
                                  }),
                                ),
                              ),
                              Consumer(builder: (context, ref, child) {
                                return BottomButton(
                                  title: '변경하기',
                                  onTap: nicknameEditingController.text.isEmpty
                                      ? null
                                      : () async {
                                          var key = _fbKey.currentState!;

                                          if (key.saveAndValidate()) {
                                            FocusScope.of(context).unfocus();

                                            await ref.watch(onBoardingProvider.notifier).putMyInformation(
                                                  nickname: nicknameEditingController.text,
                                                  isOnBoarding: false,
                                                  isPutNickname: true,
                                                  context: context,
                                                );
                                          }
                                        },
                                );
                              }),
                            ],
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
              Divider(
                thickness: 1.h,
                height: 1.h,
                color: Theme.of(context).colorScheme.border,
              ),
              ProfileButton(
                isBirth: true,
                icon: SvgPicture.asset(
                  "lib/config/assets/images/profile/navigate_next.svg",
                  color: Theme.of(context).colorScheme.iconSubColor,
                ),
                title: '생일 변경',
                titleColor: Theme.of(context).colorScheme.textTitle,
                onPressed: () {
                  GlobalUtils.setAnalyticsCustomEvent('Click_MyInfo_AgeEdit');
                  showModalBottomSheet(
                    backgroundColor: Theme.of(context).colorScheme.backgroundModal,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25.0),
                      ),
                    ),
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => StatefulBuilder(builder: (context, StateSetter setState) {
                      return FormBuilder(
                        key: _fbKey,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 40.0.h,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 24.0.w),
                                child: Text(
                                  "생일 변경",
                                  style: kHeader4Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(24.w),
                                child: AgeTextField(
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                  isSettingAge: true,
                                  textEditingController: ageEditingController,
                                  onTap: () {
                                    DatePicker.showPicker(
                                      context,
                                      pickerModel: MonthDayModel(
                                        currentTime: DateTime.parse(
                                          ref.watch(onBoardingProvider).age == '' || ref.watch(onBoardingProvider).age == null ? "2000-01-01" : ref.watch(onBoardingProvider).age!,
                                        ),
                                        minTime: DateTime(1930, 1, 1),
                                        maxTime: DateTime(2022, 12, 31),
                                        locale: LocaleType.ko,
                                      ),
                                      showTitleActions: true,
                                      onConfirm: (date) {
                                        getBirthDateFormat(date);
                                        setState(() {});
                                      },
                                      // currentTime: DateTime.parse(
                                      //   ref.watch(onBoardingProvider).age == '' || ref.watch(onBoardingProvider).age == null ? "2000-01-01" : ref.watch(onBoardingProvider).age!,
                                      // ),
                                      locale: LocaleType.ko,
                                      theme: picker_theme.DatePickerTheme(
                                        itemStyle: kSubtitle1Style.copyWith(color: Theme.of(context).colorScheme.textBody),
                                        backgroundColor: Theme.of(context).colorScheme.backgroundModal,
                                        title: "생일 변경",
                                      ),
                                    );
                                  },
                                  suffixIcon: Consumer(builder: (context, ref, child) {
                                    return ageEditingController.text.isEmpty
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
                                            onTap: () {
                                              ageEditingController.clear();
                                              setState(() {});
                                            },
                                          );
                                  }),
                                  hintText: ref.watch(onBoardingProvider).age == '' || ref.watch(onBoardingProvider).age == null ? "01-01" : ref.watch(onBoardingProvider).age!.replaceAll("2000-", ""),
                                ),
                              ),
                              Consumer(builder: (context, ref, child) {
                                return BottomButton(
                                  title: '변경하기',
                                  onTap: ageEditingController.text.isEmpty
                                      ? null
                                      : () async {
                                          var key = _fbKey.currentState!;
                                          if (key.saveAndValidate()) {
                                            FocusScope.of(context).unfocus();

                                            await ref.watch(onBoardingProvider.notifier).putMyInformation(
                                                  age: "2000-${ageEditingController.text}",
                                                  isOnBoarding: false,
                                                  isPutNickname: false,
                                                  context: context,
                                                );

                                            // ignore: use_build_context_synchronously
                                            Navigator.pop(context);
                                            // ignore: use_build_context_synchronously
                                            toast(
                                              context: context,
                                              text: '변경을 완료했어요.',
                                              isCheckIcon: true,
                                            );
                                          }
                                        },
                                );
                              }),
                            ],
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
              Divider(
                thickness: 1.h,
                height: 1.h,
                color: Theme.of(context).colorScheme.border,
              ),
              ProfileButton(
                icon: SvgPicture.asset(
                  "lib/config/assets/images/profile/navigate_next.svg",
                  color: Theme.of(context).colorScheme.iconSubColor,
                ),
                title: '직업 변경',
                titleColor: Theme.of(context).colorScheme.textTitle,
                onPressed: () {
                  GlobalUtils.setAnalyticsCustomEvent('Click_MyInfo_JobEdit');
                  jobStatus = EnumToString.fromString(Job.values, ref.watch(onBoardingProvider).job);

                  showModalBottomSheet(
                    backgroundColor: Theme.of(context).colorScheme.backgroundModal,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25.0),
                      ),
                    ),
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, StateSetter setState) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 40.0.h,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 24.0.w),
                                  child: Text(
                                    "직업 변경",
                                    style: kHeader4Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20.0.h),
                                  child: GridView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: jobList.length,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      childAspectRatio: 0.8.h,
                                    ),
                                    itemBuilder: (BuildContext context, int i) {
                                      return Consumer(builder: (context, ref, child) {
                                        return JobButton(
                                          job: jobList[i].name,
                                          icon: jobList[i].icon,
                                          selected: jobStatus == Job.values[i],
                                          onPressed: () {
                                            jobStatus = Job.values[i];

                                            setState(() {});
                                          },
                                        );
                                      });
                                    },
                                  ),
                                ),
                                Consumer(builder: (context, ref, child) {
                                  return BottomButton(
                                    title: '변경하기',
                                    onTap: jobStatus == null
                                        ? null
                                        : () async {
                                            await ref.watch(onBoardingProvider.notifier).putMyInformation(
                                                  job: jobStatus!.name,
                                                  isOnBoarding: false,
                                                  isPutNickname: false,
                                                  context: context,
                                                );

                                            // ignore: use_build_context_synchronously
                                            Navigator.pop(context);
                                            // ignore: use_build_context_synchronously
                                            toast(
                                              context: context,
                                              text: '변경을 완료했어요.',
                                              isCheckIcon: true,
                                            );
                                          },
                                  );
                                }),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
              Divider(
                thickness: 12.h,
              ),
              ProfileButton(
                icon: SvgPicture.asset(
                  "lib/config/assets/images/profile/navigate_next.svg",
                  color: Theme.of(context).colorScheme.iconSubColor,
                ),
                title: '로그아웃',
                titleColor: Theme.of(context).colorScheme.textTitle,
                onPressed: () async {
                  GlobalUtils.setAnalyticsCustomEvent('Click_Logout');
                  showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (ctx) {
                      return DialogComponent(
                        title: "로그아웃 하시겠어요?",
                        content: Text(
                          "다음에 또 만나요!",
                          style: kHeader6Style.copyWith(color: Theme.of(context).colorScheme.textSubtitle),
                        ),
                        actionContent: [
                          DialogButton(
                            title: "아니요",
                            onTap: () {
                              Navigator.pop(context);
                            },
                            backgroundColor: Theme.of(context).colorScheme.secondaryColor,
                            textStyle: kHeader4Style.copyWith(color: Theme.of(context).colorScheme.textSubtitle),
                          ),
                          SizedBox(
                            width: 12.w,
                          ),
                          DialogButton(
                            title: "예",
                            onTap: () async {
                              ref.watch(onBoardingProvider.notifier).clearMyInformation();
                              widget.isKakaoLogin ? await ref.watch(loginProvider.notifier).kakaoLogout() : await ref.watch(loginProvider.notifier).appleLogout();

                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                  (route) => false);
                            },
                            backgroundColor: kOrange200Color,
                            textStyle: kHeader4Style.copyWith(color: kWhiteColor),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              Divider(
                thickness: 1.h,
              ),
              GestureDetector(
                onTap: () {
                  GlobalUtils.setAnalyticsCustomEvent('Click_Withdraw');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WithdrawScreen(
                        isKakaoLogin: widget.isKakaoLogin,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    '회원탈퇴',
                    style: kHeader5Gray300UnderlineStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
