import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/domains/main/provider/main_provider.dart';
import 'package:frontend/domains/password/provider/password_provider.dart';
import 'package:frontend/ui/layout/default_layout.dart';
import 'package:frontend/ui/screen/password/components/password_keyboard.dart';
import 'package:frontend/ui/screen/password/components/password_text_display.dart';
import 'package:vibration/vibration.dart';

class PasswordVerificationScreen extends ConsumerStatefulWidget {
  final Widget Function(BuildContext) nextPage;

  const PasswordVerificationScreen({
    super.key,
    required this.nextPage,
  });

  @override
  PasswordVerificationScreenState createState() => PasswordVerificationScreenState();
}

class PasswordVerificationScreenState extends ConsumerState<PasswordVerificationScreen> {
  String? passwordKeyword;
  String passwordText = "비밀번호를 입력해주세요";
  String enteredPassword = '';
  int failedAttempts = 0;

  @override
  void initState() {
    super.initState();
    passwordKeyword = '';

    ref.read(mainProvider).isBioAuth ? verificationBioAuth("") : null;
  }

  verificationBioAuth(val) async {
    if (await ref.read(passwordProvider.notifier).authenticateWithBiometrics(
          isAuthenticateToggle: false,
          context: context,
        )) {
      goToNextPage();
    }
  }

  goToNextPage() {
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: widget.nextPage), (route) => false);
  }

  verifyPassword() async {
    final storedPassword = ref.read(mainProvider).password;
    if (enteredPassword == storedPassword) {
      goToNextPage();
    } else {
      setState(() {
        passwordText = '비밀번호가 일치하지 않아요\n다시 한 번 더 입력해주세요';
        passwordKeyword = '';
        enteredPassword = '';
        failedAttempts++;
      });
    }
  }

  onNumberPress(val) {
    Vibration.vibrate(duration: 100);
    setState(() {
      passwordKeyword = passwordKeyword! + val;
    });

    if (passwordKeyword!.length == 4) {
      enteredPassword = passwordKeyword!;
      Future.delayed(const Duration(milliseconds: 100), () {
        verifyPassword();
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
      screenName: 'Screen_Event_Profile_Password_Verification',
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              PasswordTextDisplay(
                passwordKeyword: passwordKeyword!,
                passwordText: passwordText,
                isHintVisible: failedAttempts > 0 && ref.read(mainProvider).hint != null, // 실패 횟수가 1 이상, 힌트가 있을때 노출
                hint: ref.read(mainProvider).hint,
              ),
              PasswordKeyboard(
                onNumberPress: onNumberPress,
                onBackspacePress: onBackspacePress,
                bioAuthOnTap: verificationBioAuth,
                isBioAuth: ref.read(mainProvider).isBioAuth,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
