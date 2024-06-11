import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/domains/main/provider/main_provider.dart';
import 'package:frontend/ui/components/back_icon.dart';
import 'package:frontend/ui/layout/default_layout.dart';
import 'package:frontend/ui/screen/password/components/password_keyboard.dart';
import 'package:frontend/ui/screen/password/components/password_text_display.dart';
import 'package:frontend/ui/screen/password/password_hint_setting_screen.dart';

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

    passwordKeyword = '';
  }

  successPassword() async {
    ref.read(mainProvider.notifier).enablePassword();
    ref.read(mainProvider.notifier).setPassword(secondPassword!);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PasswordHintSettingScreen(),
      ),
    );
  }

  checkAgainPassword() {
    passwordText = '비밀번호가 일치하지 않아요\n다시 한 번 더 입력해주세요';
    passwordKeyword = '';
  }

  onNumberPress(val) {
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
