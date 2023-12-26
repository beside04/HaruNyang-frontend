import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/core/utils/utils.dart';
import 'package:frontend/domains/on_boarding/provider/on_boarding_nickname/on_boarding_nickname_provider.dart';
import 'package:frontend/ui/components/bottom_button.dart';
import 'package:frontend/ui/components/nickname_text_field.dart';
import 'package:frontend/ui/screen/on_boarding/components/on_boarding_stepper.dart';
import 'package:frontend/ui/screen/on_boarding/on_boarding_age/on_boarding_age_screen.dart';

final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

class OnBoardingNicknameScreen extends ConsumerStatefulWidget {
  final String? email;
  final String loginType;
  final String socialId;

  const OnBoardingNicknameScreen({
    Key? key,
    required this.email,
    required this.loginType,
    required this.socialId,
  }) : super(key: key);

  @override
  OnBoardingNicknameScreenState createState() => OnBoardingNicknameScreenState();
}

class OnBoardingNicknameScreenState extends ConsumerState<OnBoardingNicknameScreen> {
  FocusNode nicknameFocusNode = FocusNode();
  bool btnVisible = true;

  final nicknameEditingController = TextEditingController();

  @override
  void initState() {
    nicknameFocusNode.addListener(btnVisibleChange);
    nicknameEditingController.addListener(_onNicknameChanged);
    super.initState();
  }

  @override
  void dispose() {
    nicknameFocusNode.removeListener(btnVisibleChange);
    nicknameEditingController.removeListener(_onNicknameChanged);
    nicknameFocusNode.dispose();
    super.dispose();
  }

  void _onNicknameChanged() {
    setState(() {});
  }

  void btnVisibleChange() {
    setState(() {
      btnVisible = !nicknameFocusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      screenName: 'Screen_Event_OnBoarding_NickName',
      child: WillPopScope(
        onWillPop: () async {
          bool backResult = GlobalUtils.onBackPressed();
          return await Future.value(backResult);
        },
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            body: SafeArea(
              bottom: false,
              child: FormBuilder(
                key: _fbKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: Stack(
                  children: [
                    Center(
                      child: ListView(
                        children: [
                          SizedBox(
                            height: 12.h,
                          ),
                          const OnBoardingStepper(
                            pointNumber: 1,
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
                                  "안녕하세요, 저는 하루냥이예요",
                                  style: kHeader2Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Text(
                                  "집사님을 어떻게 불러드릴까요?",
                                  style: kHeader2Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                NicknameTextField(
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                  nameHintText: '닉네임',
                                  focus: nicknameFocusNode,
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
                                            onTap: () => nicknameEditingController.clear(),
                                          );
                                  }),
                                ),
                                Consumer(builder: (context, ref, child) {
                                  return ref.watch(onBoardingNicknameProvider).isOnKeyboard
                                      ? Container()
                                      : SizedBox(
                                          height: 124.h,
                                        );
                                }),
                                Center(
                                  child: Image.asset(
                                    "lib/config/assets/images/character/character4.png",
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
                    Visibility(
                      visible: btnVisible,
                      child: Consumer(builder: (context, ref, child) {
                        print("ADSASDASD");

                        return BottomButton(
                          title: '다음',
                          onTap: nicknameEditingController.text.trim().isEmpty
                              ? null
                              : () async {
                                  var key = _fbKey.currentState!;
                                  if (key.saveAndValidate()) {
                                    FocusScope.of(context).unfocus();

                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => OnBoardingAgeScreen(
                                          nickname: nicknameEditingController.text,
                                          email: widget.email,
                                          loginType: widget.loginType,
                                          socialId: widget.socialId,
                                        ),
                                      ),
                                    );

                                    // await onBoardingController.putMyInformation(
                                    //   nickname: controller.nicknameValue.value,
                                    //   isOnBoarding: true,
                                    //   isPutNickname: true,
                                    //   context: context,
                                    // );
                                  }
                                },
                        );
                      }),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
