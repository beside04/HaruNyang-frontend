import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/domains/main/provider/main_provider.dart';
import 'package:frontend/domains/password/provider/password_provider.dart';
import 'package:frontend/main.dart';
import 'package:frontend/ui/components/back_icon.dart';
import 'package:frontend/ui/components/bottom_button.dart';
import 'package:frontend/ui/components/dialog_button.dart';
import 'package:frontend/ui/components/dialog_component.dart';
import 'package:frontend/ui/components/toast.dart';
import 'package:frontend/ui/layout/default_layout.dart';
import 'package:frontend/utils/utils.dart';

final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

class PasswordHintSettingScreen extends ConsumerStatefulWidget {
  const PasswordHintSettingScreen({
    Key? key,
  }) : super(key: key);

  @override
  PasswordHintSettingScreenState createState() => PasswordHintSettingScreenState();
}

class PasswordHintSettingScreenState extends ConsumerState<PasswordHintSettingScreen> {
  FocusNode hintFocusNode = FocusNode();
  bool btnVisible = true;

  final hintEditingController = TextEditingController();

  @override
  void initState() {
    hintEditingController.addListener(_onNicknameChanged);
    super.initState();
  }

  @override
  void dispose() {
    hintEditingController.removeListener(_onNicknameChanged);
    hintFocusNode.dispose();
    super.dispose();
  }

  void _onNicknameChanged() {
    setState(() {});
  }

  goBackPage() {
    Navigator.pop(context);
    Navigator.pop(context);
  }

  onToast() {
    toast(
      context: context,
      text: '비밀번호 설정이 완료되었어요.',
      isCheckIcon: true,
    );
  }

  registerBioPopup() {
    showDialog(
      barrierDismissible: false,
      context: navigatorKey.currentContext!,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: DialogComponent(
            titlePadding: EdgeInsets.zero,
            title: "",
            content: Column(
              children: [
                Text(
                  "생체인증 설정",
                  style: kHeader3Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Text(
                  "생체인증으로 화면잠금을\n해제할 수 있도록 설정하실래요?",
                  textAlign: TextAlign.center,
                  style: kHeader6Style.copyWith(color: Theme.of(context).colorScheme.textSubtitle),
                ),
              ],
            ),
            actionContent: [
              DialogButton(
                title: "아니오",
                onTap: () async {
                  onToast();

                  Navigator.pop(context);
                  goBackPage();
                },
                backgroundColor: Theme.of(context).colorScheme.secondaryColor,
                textStyle: kHeader4Style.copyWith(color: Theme.of(context).colorScheme.textSubtitle),
              ),
              SizedBox(
                width: 12.w,
              ),
              DialogButton(
                title: "네",
                onTap: () async {
                  if (await ref.read(passwordProvider.notifier).authenticateWithBiometrics(
                        isAuthenticateToggle: false,
                        context: context,
                      )) {
                    ref.read(mainProvider.notifier).enableBioAuth();

                    onToast();

                    Navigator.pop(context);
                    goBackPage();
                  }
                },
                backgroundColor: kOrange200Color,
                textStyle: kHeader4Style.copyWith(color: kWhiteColor),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      screenName: 'Screen_Event_Profile_Password_Hint_Setting',
      child: WillPopScope(
        onWillPop: () async {
          return await Future.value(true);
        },
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                '비밀번호 힌트',
                style: kHeader4Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
              ),
              elevation: 0,
              leading: BackIcon(
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0, right: 8.0),
                  child: TextButton(
                    onPressed: () async {
                      ref.read(mainProvider.notifier).deleteHint();

                      GlobalUtils.setAnalyticsCustomEvent('Click_Delete_Hint');

                      if (!ref.read(mainProvider).isBioAuth) {
                        registerBioPopup();
                      } else {
                        onToast();

                        goBackPage();
                      }
                    },
                    child: Text(
                      '건너뛰기',
                      style: kHeader6Style.copyWith(color: Theme.of(context).colorScheme.textSubtitle),
                    ),
                  ),
                ),
              ],
            ),
            body: FormBuilder(
              key: _fbKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Stack(
                children: [
                  Center(
                    child: ListView(
                      children: [
                        Padding(
                          padding: kPrimarySidePadding,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 124.h,
                              ),
                              Text(
                                "비밀번호를 찾는데 사용할\n힌트를 입력해주세요",
                                textAlign: TextAlign.center,
                                style: kHeader3Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                              ),
                              SizedBox(
                                height: 32,
                              ),
                              FormBuilderTextField(
                                onChanged: (value) {
                                  setState(() {});
                                },
                                maxLength: 40,
                                name: 'hint',
                                focusNode: hintFocusNode,
                                controller: hintEditingController,
                                autofocus: false,
                                style: kSubtitle1Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                                keyboardType: TextInputType.name,
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                  labelStyle: kSubtitle1Style.copyWith(color: Theme.of(context).colorScheme.placeHolder),
                                  helperText: "",
                                  counterText: "",
                                  hintText: "비밀번호 힌트를 입력해주세요.",
                                  hintStyle: kSubtitle1Style.copyWith(color: Theme.of(context).colorScheme.placeHolder),
                                  contentPadding: const EdgeInsets.only(
                                    top: 14,
                                    bottom: 14,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  suffixIcon: Consumer(builder: (context, ref, child) {
                                    return hintEditingController.text.isEmpty
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
                                            onTap: () => hintEditingController.clear(),
                                          );
                                  }),
                                ),
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
                      onTap: hintEditingController.text.trim().isEmpty
                          ? null
                          : () async {
                              var key = _fbKey.currentState!;
                              if (key.saveAndValidate()) {
                                FocusScope.of(context).unfocus();

                                ref.read(mainProvider.notifier).setHint(hintEditingController.text);

                                GlobalUtils.setAnalyticsCustomEvent('Click_Set_Hint');

                                if (!ref.read(mainProvider).isBioAuth) {
                                  registerBioPopup();
                                } else {
                                  onToast();

                                  goBackPage();
                                }
                              }
                            },
                    );
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
