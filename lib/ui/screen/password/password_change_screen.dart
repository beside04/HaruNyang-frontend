import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/providers/main/provider/main_provider.dart';
import 'package:frontend/providers/password/provider/password_provider.dart';
import 'package:frontend/ui/components/back_icon.dart';
import 'package:frontend/ui/layout/default_layout.dart';
import 'package:frontend/ui/screen/password/components/password_keyboard.dart';
import 'package:frontend/ui/screen/password/components/password_text_display.dart';
import 'package:frontend/ui/screen/password/password_hint_setting_screen.dart';
import 'package:vibration/vibration.dart';

class PasswordChangeScreen extends ConsumerStatefulWidget {
  const PasswordChangeScreen({super.key});

  @override
  PasswordChangeScreenState createState() => PasswordChangeScreenState();
}

class PasswordChangeScreenState extends ConsumerState<PasswordChangeScreen> {
  String? passwordKeyword;
  String passwordText = "현재 비밀번호를 입력해주세요";
  String firstPassword = '';
  String secondPassword = '';
  bool isCurrentPasswordVerified = false;
  int failedAttempts = 0;
  bool isNewPasswordDifferent = false;

  @override
  void initState() {
    super.initState();

    passwordKeyword = '';
    ref.read(mainProvider).isBioAuth ? verificationBioAuth("") : null;
  }

  verificationBioAuth(val) async {
    if (await ref.read(passwordProvider.notifier).authenticateWithBiometrics(isAuthenticateToggle: false, context: context)) {
      context;
      setState(() {
        isCurrentPasswordVerified = true;
        passwordKeyword = '';
        passwordText = "새로운 비밀번호를 입력해주세요";
        failedAttempts = 0;
      });
    }
  }

  verifyCurrentPassword() {
    final storedPassword = ref.read(mainProvider).password;
    if (passwordKeyword == storedPassword) {
      setState(() {
        isCurrentPasswordVerified = true;
        passwordKeyword = '';
        passwordText = "새 비밀번호를 입력해주세요";
        failedAttempts = 0;
      });
    } else {
      setState(() {
        passwordText = "비밀번호가 일치하지 않아요\n다시 한 번 더 입력해주세요";
        passwordKeyword = '';
        failedAttempts++;
      });
    }
  }

  successPassword() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PasswordHintSettingScreen(
          password: secondPassword,
          onBack: resetState,
        ),
      ),
    );
  }

  resetState() {
    ref.read(mainProvider).isBioAuth ? verificationBioAuth("") : null;
    setState(() {
      passwordKeyword = '';
      passwordText = "현재 비밀번호를 입력해주세요";
      firstPassword = '';
      secondPassword = '';
      isCurrentPasswordVerified = false;
      failedAttempts = 0;
      isNewPasswordDifferent = false;
    });
  }

  checkAgainPassword() {
    setState(() {
      passwordText = '비밀번호가 일치하지 않아요\n다시 한 번 더 입력해주세요';
      passwordKeyword = '';
    });
  }

  onNumberPress(val) {
    Vibration.vibrate(duration: 100);
    setState(() {
      passwordKeyword = passwordKeyword! + val;
    });

    if (!isCurrentPasswordVerified) {
      if (passwordKeyword!.length == 4) {
        Future.delayed(const Duration(milliseconds: 100), () {
          verifyCurrentPassword();
        });
      }
    } else {
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
          if (ref.read(mainProvider).password == passwordKeyword) {
            //이전과 같은 비밀번호 일때
            Vibration.vibrate(duration: 500);
            setState(() {
              isCurrentPasswordVerified = true;
              failedAttempts = 0;
              passwordKeyword = '';
              passwordText = '새 비밀번호를 입력해주세요';
              isNewPasswordDifferent = true; // 이전과 다른 비밀번호 체크
            });
          } else {
            setState(() {
              firstPassword = passwordKeyword!;
              passwordKeyword = '';
              passwordText = '비밀번호를 한 번 더 입력해주세요';
              isNewPasswordDifferent = false;
            });
          }
        });
      }
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
      screenName: 'Screen_Event_Profile_Password_Change',
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '비밀번호 변경',
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
                isHintVisible: failedAttempts > 0 && ref.read(mainProvider).hint != null,
                // 실패 횟수가 1 이상, 힌트가 있을때 노출
                hint: ref.read(mainProvider).hint,
                isNewPasswordDifferent: isNewPasswordDifferent,
              ),
              PasswordKeyboard(
                onNumberPress: onNumberPress,
                onBackspacePress: onBackspacePress,
                bioAuthOnTap: verificationBioAuth,
                isBioAuth: isCurrentPasswordVerified ? null : ref.read(mainProvider).isBioAuth,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
