import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/main.dart';
import 'package:frontend/ui/components/back_icon.dart';
import 'package:frontend/ui/components/dialog_button.dart';
import 'package:frontend/ui/components/dialog_component.dart';
import 'package:frontend/ui/layout/default_layout.dart';
import 'package:frontend/ui/screen/password/components/password_keyboard.dart';
import 'package:frontend/ui/screen/password/components/password_text_display.dart';
import 'package:frontend/ui/screen/password/password_hint_setting_screen.dart';
import 'package:vibration/vibration.dart';

class PasswordSettingScreen extends ConsumerStatefulWidget {
  const PasswordSettingScreen({super.key});

  @override
  PasswordSettingScreenState createState() => PasswordSettingScreenState();
}

class PasswordSettingScreenState extends ConsumerState<PasswordSettingScreen> {
  String? passwordKeyword;
  String passwordText = "비밀번호를 입력해주세요";
  String firstPassword = '';
  String secondPassword = '';

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
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
                    "비밀번호 설정",
                    style: kHeader3Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Text(
                    "비밀번호를 분실하면 찾을 수 없으니\n신중하게 설정해주세요!",
                    textAlign: TextAlign.center,
                    style: kHeader6Style.copyWith(color: Theme.of(context).colorScheme.textSubtitle),
                  ),
                ],
              ),
              actionContent: [
                DialogButton(
                  title: "취소",
                  onTap: () async {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  backgroundColor: Theme.of(context).colorScheme.secondaryColor,
                  textStyle: kHeader5Style.copyWith(color: Theme.of(context).colorScheme.textSubtitle),
                ),
                SizedBox(
                  width: 12.w,
                ),
                DialogButton(
                  title: "비밀번호 설정",
                  onTap: () async {
                    Navigator.pop(context);
                  },
                  backgroundColor: kOrange200Color,
                  textStyle: kHeader5Style.copyWith(color: kWhiteColor),
                ),
              ],
            ),
          );
        },
      );
    });

    passwordKeyword = '';
  }

  successPassword() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PasswordHintSettingScreen(
          password: secondPassword,
          onBack: () {},
        ),
      ),
    );
  }

  checkAgainPassword() {
    passwordText = '비밀번호가 일치하지 않아요\n다시 한 번 더 입력해주세요';
    passwordKeyword = '';
  }

  onNumberPress(val) {
    Vibration.vibrate(duration: 100);
    setState(() {
      passwordKeyword = passwordKeyword! + val;
    });

    if (firstPassword.length == 4) {
      setState(() {
        secondPassword = passwordKeyword!;
      });
    }

    if (secondPassword.length == 4) {
      Future.delayed(const Duration(milliseconds: 100), () {
        setState(() {
          passwordKeyword = '';
        });

        if (firstPassword == secondPassword) {
          successPassword();
        } else {
          checkAgainPassword();
        }
      });
    }

    if (passwordKeyword!.length == 4 && firstPassword.isEmpty) {
      Future.delayed(const Duration(milliseconds: 100), () {
        setState(() {
          firstPassword = passwordKeyword!;
          passwordKeyword = '';
          passwordText = '비밀번호를 한 번 더 입력해주세요';
        });
      });
    }
  }

  onBackspacePress(val) {
    Vibration.vibrate(duration: 100);
    setState(() {
      if (passwordKeyword!.isNotEmpty) {
        passwordKeyword = passwordKeyword!.substring(0, passwordKeyword!.length - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      screenName: 'Screen_Event_Profile_Password_Setting',
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '비밀번호 설정',
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
          child: Column(
            children: [
              PasswordTextDisplay(
                passwordKeyword: passwordKeyword!,
                passwordText: passwordText,
              ),
              PasswordKeyboard(
                onNumberPress: onNumberPress,
                onBackspacePress: onBackspacePress,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
