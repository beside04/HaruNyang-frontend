import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/data/repository/password/password_repository_impl.dart';
import 'package:frontend/domain/use_case/password_use_case/password_use_case.dart';
import 'package:frontend/providers/password/model/password_state.dart';
import 'package:frontend/ui/components/toast.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';

final passwordProvider = StateNotifierProvider<PasswordNotifier, PasswordState>((ref) {
  return PasswordNotifier(
    ref,
    PasswordUseCase(
      passwordRepository: PasswordRepositoryImpl(),
    ),
  );
});

class PasswordNotifier extends StateNotifier<PasswordState> {
  PasswordNotifier(this.ref, this.passwordUseCase) : super(PasswordState());

  final Ref ref;
  final PasswordUseCase passwordUseCase;

  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> authenticateWithBiometrics({required BuildContext context, required bool isAuthenticateToggle}) async {
    bool authenticated = false;

    try {
      // '인증 진행 중...'

      authenticated = await auth.authenticate(
        localizedReason: '지문으로 해제해주세요.',
        authMessages: [
          IOSAuthMessages(
            localizedFallbackTitle: isAuthenticateToggle ? "뒤로가기" : "비밀번호 입력하기",
          ),
          AndroidAuthMessages(
            biometricHint: "",
            cancelButton: isAuthenticateToggle ? "뒤로가기" : "비밀번호 입력하기",
            signInTitle: "생체 정보로 인증해주세요.",
          ),
        ],
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
          useErrorDialogs: false,
        ),
      );

      // '인증 진행 중...'
    } on PlatformException catch (e) {
      print(e.code);
      // 등록된 지문이 없을때 e.code == NotEnrolled (에러)
      // 사용중인 기기에 생체인증 정보가 없어요.
      if (e.code == "NotEnrolled") {
        toast(
          context: context,
          text: '사용중인 기기에 생체인증 정보가 없어요.',
          isCheckIcon: false,
        );
      } else {
        toast(
          context: context,
          text: '생체 인증중 문제가 생겼어요.',
          isCheckIcon: false,
        );
      }

      return false;
    }

    if (!mounted) {
      return false;
    }

    return authenticated;
  }

  void setSelectedIndex(int index) {
    state = state.copyWith(selectedIndex: index);
  }
}
