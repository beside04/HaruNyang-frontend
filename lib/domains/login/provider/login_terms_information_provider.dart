import 'package:frontend/domain/use_case/push_message/push_message_use_case.dart';
import 'package:frontend/domain/use_case/social_login_use_case/apple_login_use_case.dart';
import 'package:frontend/domain/use_case/social_login_use_case/kakao_login_use_case.dart';
import 'package:frontend/domains/login/model/login_terms_information_state.dart';
import 'package:frontend/ui/screen/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/main.dart';
import 'package:frontend/data/repository/push_messge/push_message_repository_impl.dart';

final loginTermsInformationProvider = StateNotifierProvider<MainNotifier, LoginTermsInformationState>((ref) {
  return MainNotifier(
    ref,
    kakaoLoginUseCase,
    appleLoginUseCase,
    PushMessageUseCase(
      pushMessagePermissionRepository: PushMessageRepositoryImpl(),
    ),
  );
});

class MainNotifier extends StateNotifier<LoginTermsInformationState> {
  MainNotifier(this.ref, this.kakaoLoginUseCase, this.appleLoginUseCase, this.pushMessagePermissionUseCase)
      : super(
          LoginTermsInformationState(),
        );

  final Ref ref;
  final KakaoLoginUseCase kakaoLoginUseCase;
  final AppleLoginUseCase appleLoginUseCase;
  final PushMessageUseCase pushMessagePermissionUseCase;

  void toggleAllCheck() {
    state = state.copyWith(isAllCheckAgree: !state.isAllCheckAgree);

    if (state.isAllCheckAgree) {
      state = state.copyWith(
        isTermsAgree: true,
        isPrivacyPolicyAgree: true,
        isMarketingConsentAgree: true,
      );
      pushMessagePermissionUseCase.setMarketingConsentAgree(true.toString());
    } else {
      state = state.copyWith(
        isTermsAgree: false,
        isPrivacyPolicyAgree: false,
        isMarketingConsentAgree: false,
      );
      pushMessagePermissionUseCase.setMarketingConsentAgree(false.toString());
    }
  }

  void toggleTermsCheck() {
    state = state.copyWith(isTermsAgree: !state.isTermsAgree);
  }

  void togglePrivacyPolicyCheck() {
    state = state.copyWith(isPrivacyPolicyAgree: !state.isPrivacyPolicyAgree);
  }

  void toggleMarketingConsentCheck() {
    if (state.isMarketingConsentAgree) {
      state = state.copyWith(isMarketingConsentAgree: false);
      pushMessagePermissionUseCase.setMarketingConsentAgree(false.toString());
    } else {
      state = state.copyWith(isMarketingConsentAgree: true);
      pushMessagePermissionUseCase.setMarketingConsentAgree(true.toString());
    }
  }

  void goToLoginScreen(String loginType) {
    navigatorKey.currentState!.pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => LoginScreen(
                  isSignup: true,
                  loginType: loginType,
                )),
        (route) => false);
  }
}
